# Release Notes

2.1.0 Mar 25, 2022
* Remove certs

2.0.2 Feb 16, 2022
* Fix issue with installing krew

2.0.1 Dec 9, 2021
* Revert to ARG declarations on separate lines to support versions of Docker before 20.10.0

2.0.0 July 13, 2021
* upgrade to Ubuntu 20:04
* streamline Dockerfile

1.3.0 May 19, 2021
* improve MAC experience

1.2.1 Nov 12, 2020
* add release notes and versioning

1.2.0 Nov 11, 2020
* add `kustomize` to dev tools

1.1.1 Nov 6, 2020
* update `az-get-credentials` to optionally set the namespace associated with the context
* only merge kubeconfig if its newer than existing one in `~/.kube/config`
* update `no_proxy` to fix issue with `127.0.0.1`

1.1.0 Oct 30, 2020
* add `kpt` to dev tools
* fix issue with docker build/run/create not using proxies

1.0.1 Oct 14, 2020
* multiple changes

1.0.0 Oct 6, 2020
* initial release

0.1.0 Sep 29, 2020
* beta release
