# OSTIS-web-platform

<img src="https://github.com/ostis-ai/ostis-web-platform/actions/workflows/main.yml/badge.svg?branch=develop">

## Documentation:

This repository represents ***the OSTIS Technology web-oriented platform*** implementation. You can use it to store, represent 
and process your information in formal language of universal representation of knowledge. The OSTIS Technology platform 
is associated with the IMS system. 

The OSTIS Technology platform contains:
1) [Knowledge base with top-level ontologies](https://github.com/ostis-ai/ims.ostis.kb) to specify any information models 
in scope of any subject domains;
2) [Knowledge processing machine](https://github.com/ostis-ai/sc-machine) with semantic network storage and their 
processing with tools to interact with it;
3) [Web-oriented semantic interface](https://github.com/ostis-ai/sc-web) to users interact with the IMS system.

# Installation
## Using Docker
You will need [Docker](https://docs.docker.com/get-docker/) installed and running on your machine.

```sh
git clone https://github.com/ostis-ai/ostis-web-platform
cd ostis-web-platform
docker compose pull
```

<details> 
<summary> Building images locally </summary>

e.g. when you want to launch a custom branch of sc-machine/sc-web
#### Requirements
1. **If you're using Windows**, please make sure you are using UNIX line endings inside the repository and `longpaths` are enabled:
   ```
   git config --local core.autocrlf true
   git config --local core.longpaths true
   git add --normalize .
   ```
2. Enable Docker BuildKit. You can use `DOCKER_BUILDKIT=1` shell variable for this.

```sh
git clone https://github.com/ostis-ai/ostis-web-platform
git submodule update --init --recursive
cd scripts
./prepare.sh no_build_sc_web no_build_sc_web no_build_kb # download all submodules (without compilation)
cd ..
docker compose build
```
</details>




## Natively
Note: Currently only Ubuntu is supported by this installation method. If you're going to use it, all build-time dependencies will be downloaded to your computer, and it might take a while to compile the `sc-machine`. Use it only if you know what you're doing!
```sh
cd ostis-web-platform/scripts/
./prepare.sh
```

# Usage
## Docker
```sh
# This command will build the Knowledge Base.
# You need to launch it only before the first launch (or if you've made updates to KB sources)
docker compose run machine build
# This will start platform services and run web interface at localhost:8000
docker compose up
```

## Native installation
After run the following script for sc-server to interact with knowledge processing machine:
```sh
cd ostis-web-platform/scripts/
./run_sc_server.sh
```

To see and interact you with system run the following script for interface:
```sh
cd ostis-web-platform/scripts/
./run_scweb.sh
```

# Documentation on SC-code representation
We represent all information about project development and its components' implementation in sources of its knowledge 
base to provide opportunity to use it in information processing and knowledge creating. Documentation is written with 
the help of LaTex tools in SCn-code representation. To see more information about [the OSTIS Technology](https://github.com/ostis-ai/ostis-standard) 
web-oriented platform implementation:

We're providing a Docker image to build the documentation.

To do that, run docker image:
```sh
docker run -v </full/path/to/ostis-web-platform>:/workdir ostis/scn-latex-plugin:latest docs/main.tex
```
After the compilation, the `main.pdf` file should appear at `ostis-web-platform/docs/`.

Alternatively, you can use any LaTeX distribution to build and view the documentation, but you will have to install all
dependencies manually. We use own LaTeX plugin as a submodule, to build docs natively you can read more about usage of 
this plugin [here](https://github.com/ostis-ai/scn-latex-plugin).
