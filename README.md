<img src="https://github.com/ostis-ai/ostis-web-platform/actions/workflows/main.yml/badge.svg?branch=develop">

### Documentation:

This repository represents the OSTIS Technology web-oriented platform implementation. You can use it to store, represent 
and process your information in formal language of universal representation of knowledge. The OSTIS Technology platform 
is associated with the IMS system. 

The OSTIS Technology platform contains:
1) Knowledge base with top-level ontologies to specify any information models in scope of any subject domains;
2) Knowledge processing machine with semantic network storage and their processing with tools to interact with it;
3) Web-oriented semantic interface to users interact with the IMS system.

# Installation
To run OSTIS Technology platform execute the following scripts to install and build all their submodules:

## Initiate and update submodules
```sh
cd ostis-web-platform/scripts/
./prepare.sh
```

# Usage
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
the help of LaTex tools in SCn-code representation. To see more information about the OSTIS Technology web-oriented 
platform implementation:

## Docker
We're providing a Docker image to build the documentation. Head to [Installing with Docker](https://docs.docker.com/get-started/) 
section of our docs to try it out!

To do that, run docker image:
```sh
cd ostis-web-platform/docs/scn/
docker run -v </full/path/to/ostis-web-platform>:/workdir ostis/scntex-builder 'cd docs && pdflatex -interaction=nonstopmode main.tex'
```
After the compilation, the `main.pdf` file should appear at `ostis-web-platform/docs/`.

Alternatively, you can use any LaTeX distribution to build and view the documentation, but you will have to install all
dependencies manually.
