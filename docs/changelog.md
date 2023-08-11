# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Generalize all scripts
- Configure events and agents threads

### Changed
- Link scripts with sc-machine and sc-web scripts
- Unify config file for sc-server and sc-builder

### Deprecated
- Deprecate `run_scweb.sh`, add `run_sc_web.sh` instead
- Deprecate and divide `prepare.sh` into `install_submodules.sh`, `install_dependencies.sh`, `build_sc_machine.sh` and `build_sc_web.sh`

### Removed
- Remove windows scripts
- Remove drawings and scp scripts
- Remove dump scripts
- Remove sctp-server scripts

## [0.7.0-Rebirth] - 13.10.2022
### Breaking actions
- Remove sctp-server scripts from projects that use ostis-web-platform
- Use py-sc-client and ts-sc-client for sc-server instead of sctp-clients for sctp-server

### Added
- Add latex documentation from OSTIS Standard
- Add CI

### Changed
- Unify config file for sc-server and sc-builder

### Removed
- Remove sctp-server scripts

## [0.6.1] - 28.04.2022
### Added
- Add sc-machine gitmodules initiation

### Changed
- Set modules links to ostis-ai repos

### Removed
- Remove yarn web interface build
