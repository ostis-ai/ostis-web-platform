# ostis-web-platform

<img src="https://github.com/ostis-ai/ostis-web-platform/actions/workflows/install.yml/badge.svg?branch=develop"> [![license](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
 
It is the repository of the Platform of the [OSTIS Technology](https://github.com/ostis-ai). The OSTIS Platform is intended to be a solid framework to help you deploy existing and create new ostis-systems.

OSTIS Platform contains:

1. [Knowledge base with top-level ontologies](https://github.com/ostis-ai/ims.ostis.kb)
2. [Semantic network storage for intelligent systems](https://github.com/ostis-ai/sc-machine)
3. [Interpreter of semantic network programs of intelligent systems](https://github.com/ostis-ai/scp-machine)
4. [Component manager for intelligent systems](https://github.com/ostis-ai/sc-component-manager)
5. [Interpreter of web-oriented semantic interfaces of intelligent systems](https://github.com/ostis-ai/sc-web)

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
  docker compose run --rm machine build
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
  # download all submodules
  ./scripts/install_submodules.sh
  # build sc-machine, scp-machine and sc-component-manager
  docker compose build
  ```

   </details>

- Natively

  Note: Currently, only Linux (Ubuntu-22.04, Ubuntu-24.04) and macOS are supported by this installation method.

  ```sh
  git clone https://github.com/ostis-ai/ostis-web-platform --recursive
  cd ostis-web-platform
  ./scripts/install_submodules.sh

  # to build sc-machine, see https://ostis-ai.github.io/sc-machine/build/quick_start/#start-develop-sc-machine-with-conan
  cd sc-machine
  # make sure, that you have `conan`, updated `cmake` and `ninja`
  cmake --preset release-conan
  cmake --build --preset release
  conan install . --build=missing
  conan export-pkg .
  cd ..

  # to build scp-machine, see https://ostis-ai.github.io/scp-machine/build/quick_start/#start-develop-scp-machine-with-conan
  cd scp-machine
  conan install . -s build_type=Debug --build=missing
  cmake --preset debug-conan
  cmake --build --preset debug
  cd ..

  # to build sc-component-manager, see https://ostis-ai.github.io/sc-component-manager/build/quick_start/#start-develop-sc-component-manager-with-conan
  cd sc-component-manager
  conan install . -s build_type=Debug --build=missing
  cmake --preset debug-conan
  cmake --build --preset debug
  cd ..

  # to build sc-web, see https://github.com/ostis-ai/sc-web/blob/main/README.md
  cd interface/sc-web
  ./scripts/install_dependencies.sh
  npm run build
  cd ../..

  # after building projects there should be `build/Release` folder in sc-machine and `build/Debug` folders in scp-machine and sc-component-manager
  ```

## Usage

- Docker Compose

  ```sh
  # build the knowledge base
  # required before the first startup 
  # (or if you've made updates to knowledge base sources)
  docker compose run --rm machine build
  # start platform services and run web interface at localhost:8000
  docker compose up
  ```

- Native

  Run in the first terminal:

  ```sh
  # to run sc-machine, see https://ostis-ai.github.io/sc-machine/build/quick_start/#run-sc-machine-in-release
  ./sc-machine/build/Release/bin/sc-builder -i repo.path -o kb.bin --clear
  ./sc-machine/build/Release/bin/sc-machine -s kb.bin -c ostis-web-platform.ini \
    -e "sc-machine/build/Release/lib/extensions;scp-machine/build/Debug/lib/extensions;sc-component-manager/build/Debug/lib/extensions"
  ```

  Run in the second terminal:

  ```sh
  cd interface/sc-web
  source .venv/bin/activate && python3 server/app.py
  ```

## Documentation

We document all information about the project development and its components' implementation in sources of its knowledge base
to provide opportunity to use it in information processing and knowledge generation.

You can access the current version of the documentation in [docs/main.pdf](docs/main.pdf) file of this project.

Documentation is written with the help of LaTeX tools in SCn-code representation. To build documentation manually, you'll need a LaTeX distribution installed on your computer. Alternatively, we provide a Docker image to build the documentation in case you can't / don't want to install LaTeX on your PC.

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
