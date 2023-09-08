# OSTIS Web Platform

<img src="https://github.com/ostis-ai/ostis-web-platform/actions/workflows/main.yml/badge.svg?branch=develop"> [![license](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

This repository is a web-oriented software platform of the [OSTIS Project](https://github.com/ostis-ai/ostis-project) and is intended to be a solid framework to help you deploy existing and create new OSTIS systems.

OSTIS Web platform contains:

1. [Knowledge base with top-level ontologies](https://github.com/ostis-ai/ims.ostis.kb) to help you develop a broad variety of information models
2. [Knowledge processing machine](https://github.com/ostis-ai/sc-machine) with semantic network storage and agent-based knowledge processing
3. [Web-oriented semantic interface](https://github.com/ostis-ai/sc-web) for users to interact with the intelligent system.

To learn more about the platform, check out our [documentation](https://github.com/ostis-ai/ostis-web-platform/blob/develop/docs/main.pdf).

## Installation

- Quick start using Docker Compose

  <details>

  <summary><b>Additional steps for Windows users</b></summary>

  Make sure you are using UNIX line endings inside the repository and `longpaths` are enabled, otherwise you may face problems during build or installation process. Use the commands below to reconfigure Git on your machine:

    ```sh
    git config --global core.autocrlf input
    git config --global core.longpaths true
    ```

  </details>

  Requirements: you will need [Docker](https://docs.docker.com/get-docker/) installed and running on your machine.

  ```sh
  git clone https://github.com/ostis-ai/ostis-web-platform --recursive
  cd ostis-web-platform
  # download images from Docker Hub
  docker compose pull
  # build knowledge base
  docker compose run machine build
  # launch web platform stack
  docker compose up
  ```

   <details>
   <summary> Building docker images locally </summary>

  This may come in handy e.g. when you want to use a custom branch of the sc-machine or sc-web.

  ### Requirements:

  1. In case you're using Windows, set up git using the installation instructions above
  2. Enable Docker BuildKit. You can use `DOCKER_BUILDKIT=1` shell variable for this.

  ### Build process

  ```sh
  git clone https://github.com/ostis-ai/ostis-web-platform --recursive
  cd ostis-web-platform
  ./scripts/install_submodules.sh # download all submodules without compilation.
  docker compose build
  ```

   </details>

- Natively

  Note: Currently, only Linux (Ubuntu-20.04, Ubuntu-22.04) and macOS are supported by this installation method. If you're going to use it, it might take a while to download dependencies and compile the components. Use it only if you know what you're doing!

  ```sh
  git clone https://github.com/ostis-ai/ostis-web-platform --recursive
  cd ostis-web-platform
  ./scripts/install_platform.sh
  ```

- Natively (using sc-component-manager)

  ```sh
  git clone https://github.com/ostis-ai/ostis-web-platform
  cd ostis-web-platform/scripts
  git checkout feature/component_manager
  ./install_component_manager_platform.sh
  ./build_kb.sh
  cd ../sc-machine/scripts
  ./run_sc_component_manager.sh -c ../../ostis-web-platform.ini
  ```

## Usage

- Docker Compose

  ```sh
  # build the Knowledge Base.
  # Required before the first startup (or if you've made updates to KB sources)
  docker compose run machine build
  # start platform services and run web interface at localhost:8000
  docker compose up
  ```

- Native installation

  ```sh
  # Launch knowledge processing machine
  ./scripts/run_sc_server.sh
  # *in another terminal*
  # Launch semantic web interface at localhost:8000
  ./scripts/run_sc_web.sh
  ```

## Documentation

We document all information about the project development and its components' implementation in sources of its knowledge base
to provide opportunity to use it in information processing and knowledge generation.

You can access the current version of the documentation in [docs/main.pdf](docs/main.pdf) file of this project.

Documentation is written with
the help of LaTeX tools in SCn-code representation. To build documentation manually, you'll need a LaTeX distribution installed on your computer. Alternatively, we provide a Docker image to build the documentation in case you can't / don't want to install LaTeX on your PC.

### Download scn-tex-plugin and documentation for subprojects

```sh
# feel free to skip this step if the platform is already installed natively
./scripts/install_submodules.sh
```

- ### Build steps (using LaTeX)

  ```sh
  cd docs
  TEXINPUTS=./scn: latexmk -pdf -bibtex main.tex
  ```

- ### Build steps (using Docker)

  ```sh
  docker run -v ${PWD}:/workdir --rm -it ostis/scn-latex-plugin:latest "docs/main.tex"
  ```

  After the compilation, the `main.pdf` file should appear at `ostis-web-platform/docs/`. You can find more information about [scn-latex-plugin here](https://github.com/ostis-ai/scn-latex-plugin).

## Feedback

Contributions, bug reports and feature requests are welcome! Feel free to check our [issues page](https://github.com/ostis-ai/ostis-web-platform/issues) and file a new issue (or comment in existing ones).

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
