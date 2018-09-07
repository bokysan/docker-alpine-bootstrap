Just a basic alpine image with a few tools to enable you to better start of your work.

Mostly useful for Kubernetes [init containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
and debugging your containers

If you are missing anything, send in a merge request. Let's just not overdoit, folks.
Currently available:
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

I might consider adding python and perl in the future.

