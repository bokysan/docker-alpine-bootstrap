# About

A basic Alpine image with a few tools to enable you to better start of your work.

Mostly useful for Kubernetes [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
and debugging your own containers.

If you are missing anything, send in a merge request. Let's just not overdoit, folks.
Currently available:
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- awk (gawk)
- bash
- busybox (with aliaes for lots of tools...)
- bzip2
- curl
- gzip / gunzip
- sed
- wget
- xz
- postgres client (psql)
- libressl (openssl fork)
- vim (who can live without it)

I might consider adding python and/or perl in the future, but they just seem too big ATM.

# Wait for service in Kubernetes

This image also includes a bash script `wait-for-service`, which will wait for a given service to be up before
continuing. It's API/parameter compatible with 
[fabric8-dependency-wait-service](https://github.com/fabric8-services/fabric8-dependency-wait-service) but
since it's written in BASH and not GO:
- the image is much smaller
- there's no need to include different binaries for different platforms
- more platforms are automatically supported out of the box (e.g. wherever BASH works)

## Environment variables

The following variables can be used to control the service:

| Variable | Possible values | Default value | Description |
| -------- | --------------- | ------------- | ----------- |
| `DEPENDENCY_LOG_VERBOSE` | `true`/`false` | `true` | Puts out a little extra logging into output. (like *fabric8*) |
| `DEPENDENCY_POLL_INTERVAL` | A positive integer | 2 | The interval, in seconds, between each poll of the dependency check. (like *fabric8*) |
| `DEPENDENCY_CONNECT_TIMEOUT` | A positive integer | 5 | How long to wait before the service timeouts, in seconds. (not possible with *fabric8*) |

## Usage
This utility is used as part of the [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).  An example is given below.

```yaml
spec:
  initContainers:
    - name: web-for-services
      image: "boky/alpine-bootstrap"
      command: [ 'wait-for-service', 'postgres://user@host:port', 'https://whole-url-to-service', 'tcp://host:port', ... ]
      # Or, using the fabric8-compatible symlink
      command: [ 'fabric8-dependency-wait-service-linux-amd64', 'postgres://user@host:port', 'https://whole-url-to-service', 'tcp://host:port', ... ]
      env:
        - name: DEPENDENCY_POLL_INTERVAL
          value: "10"
        - name: DEPENDENCY_LOG_VERBOSE
          value: "false"
        - name: DEPENDENCY_CONNECT_TIMEOUT
          value: "10"
```

## Supported protocols

The following protocols are supported:
* **HTTP**: Anything that starts with `http://` or `https://` is considered a HTTP protocol. 
  [curl](https://curl.haxx.se/) is used to make a `HTTP HEAD`request. A service is considered up if:
  * It doesn't time out
  * It returns a result in the range `2xx`
* **POSTGRES**: The syntax is: `postgres://[<user>@]<host>[:<port>]`. 
  The given postgres url is parsed for username, host, and port and passed to the 
  [pg_isready](https://www.postgresql.org/docs/10/static/app-pg-isready.html) utility. 
  The db is considered up when *pg_isready returns a zero exit code*.
* **TCP**: The syntax is: `tcp://<host>:<port>`. [Netcat](http://netcat.sourceforge.net/) is used to 
  connect to the service. Service is considered up when *netcat* successfully connects and 
  *return a zero exit code*.

