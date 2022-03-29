# linux-dev - a pre-configured Linux development environment
**linux-dev** is a Linux development environment with a focus on Kubernetes.  **linux-dev** runs on PCs, Macs, VMs, Azure VMs, anywhere Docker can run.  You can run several **linux-dev** containers on the same machine for different projects, and quickly stand up / stand down experimental **linux-dev** containers.

Developers don't want to waste time installing software, have problems with proxies and certificates, and face restrictions on what they can install on Windows and Mac laptops.  **linux-dev** is a docker image running Ubuntu 20.04 Linux, created for developers who need to use tools such as `az cli`, `kubectl`, `helm`, and `kafkacat` with files on their host laptop or computer.  Proxies and host certificates are set up for you.

Once started, **linux-dev** is persistent. Developers can install and configure software, and changes are not lost, even across reboots.  Additionally, **linux-dev** mounts a working directory from the host computer which can contain source files, a `kubeconfig` file, etc.  This allows for workflows such as editing application files on the host using a host-based editor and building/deploying the application using `az cli`, `docker`, `kubectl`, `helm`, and other tools installed in **linux-dev**.

These development tools are pre-installed:

`kubectl` with `krew` plugin manager, `docker`, `helm` 3, `az` (azure cli), `k9s`, `kafkacat`, `kpt`, `kustomize`

These Linux utilities are pre-installed:

`curl`, `wget`, `git`, `jq`, `htop`, `nano`, `vim`, `less`, `ping`, `ssh`

These custom **linux-dev** utilities are pre-installed (see [below](#linux-dev-custom-utilities) for help on these):

`set-proxy`, `no-proxy`, `merge-kubeconfig`, `az-get-credentials`, and `update-tools`

## Getting started
Before using **linux-dev**, you need to install Docker, then download this repo, then build the **linux-dev** Docker image, and finally run the **linux-dev** container.

### Docker
If you don't have Docker, install it as follows:

#### Windows
Follow the instructions here: https://docs.docker.com/docker-for-windows/install/

After installation, configure the settings in Docker per [this guide](winconfig.md).

#### Mac
Follow the instructions here: https://docs.docker.com/docker-for-mac/install/
> **Note:** If you experience high CPU usage after starting **linux-dev**, disable `Use gRPC FUSE for file sharing` in the Docker Desktop General preferences.

####  Quick install for Ubuntu x86_64/amd64:
```
# set up the repository
sudo apt-get update
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# install docker engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
# have Docker automatically restart when the system reboots
sudo systemctl enable docker
sudo systemctl enable containerd
# these commands add you to the docker group so sudo is not required to run Docker
sudo groupadd docker
sudo usermod -aG docker $(whoami)
newgrp docker
sudo systemctl restart docker
```
> **Note:** You may need to reboot to enable running Docker without `sudo`.  If this works without error you don't need to reboot:
>```
>docker ps
>```

#### Other OS's
Follow the instructions here: https://docs.docker.com/engine/install/.

### Get the linux-dev repo
Clone or [download](https://github.com/wpwoodjr/linux-dev/archive/master.zip) and unzip this repository, then `cd` to it.

### Build the linux-dev Docker image
#### Building when on a corporate network or VPN
Build the **linux-dev** docker image as follows on Linux and Mac:
```
./build.sh USERNAME ['PASSWORD']
```
Enclose PASSWORD in single quotes `'` to prevent issues with special characters.  The brackets indicate that `'PASSWORD'` is optional; if you don't supply it the script will prompt for it (don't enclose it in single quotes when prompted).

On Windows:
```
build.bat USERNAME "PASSWORD"
```
Enclose PASSWORD in double quotes `"` to prevent issues with special characters.

`USERNAME` and `PASSWORD` are used during the build process to download tools from the Internet via a corporate proxy, and are not included in the Docker image.

#### Building when not on a corporate network or VPN
Build as follows on Linux and Mac:
```
./build.sh --noproxy
```
On Windows:
```
build.bat --noproxy
```

### Run the linux-dev container in Docker
Run the **linux-dev** container in Docker as follows on Linux and Mac:
```
./run.sh "HOST-WORKING-DIRECTORY" [CONTAINER-NAME] [ADDITIONAL-ARGUMENTS]
```
`HOST-WORKING-DIRECTORY` is the working directory on your host computer or laptop which will be mounted in **linux-dev**.  It can contain source files, your kubeconfig file, etc.  Enclose it in double quotes to prevent issues with special characters such as spaces in the directory name.

By default the container is named **linux-dev**, however if you want to run more than one **linux-dev** container you can specify a different `CONTAINER-NAME` for each one.  This may be useful when working on different projects for instance.

`ADDITIONAL-ARGUMENTS` are additional arguments for the `docker run` command.  An example of `ADDITIONAL-ARGUMENTS` would be `-p 8080:8080` to map port `8080` in **linux-dev** to the host port `8080`.

> **Note:** In order to pass `ADDITIONAL-ARGUMENTS`, you must also pass `CONTAINER-NAME`.

**linux-dev** runs in the background, and will run until stopped with `docker stop linux-dev`, even across reboots.

On Windows:
```
run.bat "HOST-WORKING-DIRECTORY" [CONTAINER-NAME]
```
> **Note:** `ADDITIONAL-ARGUMENTS` is not implemented for Windows.

## Using linux-dev
### Exec-ing into linux-dev
Once **linux-dev** is up and running in Docker, run this command to exec into the **linux-dev** Linux environment (command is the same on Windows, Mac, and Linux):
```
docker exec -it [-e user=USERNAME] [-e kubeconfig=KUBECONFIG] linux-dev /bin/bash
```
> **Note:** On Linux you may need to preface the `docker` command with `sudo`.

Brackets (`[]`) indicate that the argument is optional.  If you specify `-e user=USERNAME`, **linux-dev** will set up proxy environment variables in the container for the `USERNAME` you specify.  You will be prompted for a password.
>**Note:** If you want to enter the password on the command line, add `-e passwd=PASSWORD` to the above `exec` command.  On Linux and Mac, enclose PASSWORD in single quotes (`'`); on Windows, enclose PASSWORD in double quotes (`"`).

> **Note:** If you don't specify `-e user=USERNAME`, no proxies will be set.  This is useful when you are not on a corporate network or VPN, for instance at home or on an Azure VM.

If you specify `-e kubeconfig=KUBECONFIG`, **linux-dev** will merge the specified `KUBECONFIG` file with **linux-dev**'s default kubeconfig file, located at `~/.kube/config`.  That way you will not have to put `--kubeconfig=KUBECONFIG` every time on the `kubectl` command line.
> **Note:** `KUBECONFIG`'s path must be relative to `HOST-WORKING-DIRECTORY`. For example, if it is named `kubeconfig.txt` and is in a Windows `HOST-WORKING-DIRECTORY` named `c:\Projects`, specify `kubeconfig.txt`.  If it is in `c:\Projects\config` specify `config/kubeconfig.txt` (with a forward slash `/` because **linux-dev** runs Linux).

After exec-ing into **linux-dev** you will be in the `~/work` directory, which contains the files and directories from `HOST-WORKING-DIRECTORY`.  From there, you can install and run tools as you would in a normal Ubuntu Linux environment.  For example, try running `docker version` or `sudo apt update`.  Changes made in **linux-dev** will persist until you delete it.

If you specified an optional CONTAINER-NAME when first running **linux-dev**, use that name instead of `linux-dev` in the `docker exec` command.

> **Tip:** On Windows, if the `docker` command in **linux-dev** can't find the docker daemon, follow the Docker Desktop setup instructions [here](winconfig.md#general) for exposing the docker daemon without TLS.

### linux-dev custom utilities
 These utilities can be run from within **linux-dev**.
 
 #### set proxies
 ```
 set-proxy USERNAME [PASSWORD]
 ```
This sets the Linux proxy environment variables.  The brackets indicate that `PASSWORD` is optional; if you don't specify it, **linux-dev** will prompt for it.

> **Note**: `set-proxy` is run automatically when you exec into **linux-dev** using the `-e user=USERNAME` argument.

#### remove all proxies
```
no-proxy
```
Removes the Linux proxy environment variables.  This is useful if you are not on a corporate network or VPN (for instance at home, or on an Azure VM).

#### merge a kubeconfig file
```
merge-kubeconfig KUBECONFIG
```
This merges a downloaded kubeconfig file into the default kubeconfig file at `~/.kube/config` (inside **linux-dev**).

> **Note**: `merge-kubeconfig` can be run automatically when you `docker exec` into **linux-dev** using the `-e kubeconfig=KUBECONFIG` argument.

#### get AKS credentials
```
az-get-credentials SUBSCRIPTION RESOURCE-GROUP AKS-CLUSTER-NAME [NAMESPACE]
```
This merges AKS credentials into the default kubeconfig file at `~/.kube/config` (inside **linux-dev**), and optionally sets the NAMESPACE associated with the context.

> **Note:** use your normal laptop browser when prompted to login with browser

#### update-tools
Gets latest updates for the pre-installed software tools (eg `helm`, `kubectl`, `curl`).

### Exiting linux-dev
To return to the host computer, just type exit at the **linux-dev** prompt:
```
user@linux-dev:~/work$ exit
```
**linux-dev** will keep running in the background so that you can `docker exec` into it again later, as described above.

### Stopping linux-dev
Normally you would just leave **linux-dev** running in the background.  However to stop it, first exit **linux-dev** back to the host computer, then do:
```
docker stop linux-dev
```
To start it again, type:
```
docker start linux-dev
```
>**Warning:** if you stop **linux-dev** and later `docker prune` your containers, you will lose all stopped containers including **linux-dev** and any changes you have made to it.  Files in `HOST-WORKING-DIRECTORY` and their changes will not be lost.

### Removing linux-dev
First exit **linux-dev** back to the host computer, then do:
```
docker stop linux-dev
docker rm linux-dev
```
>**Warning:** you will lose **linux-dev** and any changes you have made to it.  Files in `HOST-WORKING-DIRECTORY` and their changes will not be lost.

That's it!  Happy developing with Linux!!  Please provide any feedback via the Github issue tracker for this repo.
