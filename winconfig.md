
# Windows Docker Configuration
Once Docker Desktop is installed on Windows, first ensure Docker is set to [use Linux containers](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers).  

Then go to settings and apply these recommendations:

## General
`Start Docker Desktop when you log in` - this is recommended so that the **linux-dev** environment will start up at login and be ready when you need it.

`Expose daemon on tcp://localhost:2375 without TLS` must be checked so that Docker in **linux-dev** can function.

## Resources
### Advanced
2 CPU's and 2GB minimum of memory are recommended.
### File Sharing
Share the directory you plan to mount in **linux-dev**.  For example, share `C:\Projects`.
### Proxies
Leave at defaults.  **linux-dev** configures the proxies.
### Network
Leave at defaults

## Docker Engine
Leave at defaults

## Command Line
Leave at defaults

## Kubernetes
You can enable a local Kubernetes cluster if desired, however if you have access to a centrally supported Kubernetes cluster, you will save on memory and CPU by not enabling this.
