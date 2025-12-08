# Python on z/OS

## Sample Project Using `pyproject.toml` and Broadcom Team Build

- The goal of this project is to show the minimum amount of work needed to build a Python artifact, as described in the "Python on z/OS" technical blog series.

- This project adopts current (2025-12-10) Python configuration (`pyproject.toml`), testing (`tox`), and packaging (wheel) recommendations.

- In addition, this project provides examples on how to use Broadcom Team Build's `syncz` tooling to achieve the desired result:

  - Declarative Python version

  - Zero reliance on installed system site-packages

  - Creation of a portable z/OS artifact

  - Protection from host evolution

### `pyproject.toml`

https://packaging.python.org/en/latest/guides/writing-pyproject-toml/

- Configuration file used by packaging tools, as well as other tools such as linters, type checkers, etc

- Endorsed by the Python Packaging Authority

  - https://www.pypa.io/en/latest/

- Recommended way to package and distribute Python artifacts

### Broadcom Team Build

#### `syncz`

https://techdocs.broadcom.com/us/en/ca-mainframe-software/devops/endevor-team-build/1-0/using/the-syncz-synchronization-tool.html

- Used to synchronize files between workstation and mainframe

  - Inspired by Linux rsync

- Additional capabilities include:

  - Retrieve files from z/OS UNIX or PDSEs

  - Create a ZFS workspace

  - Issue remote shell commands, including remote build initiation after synchronization is completed

  - Nothing required to install on the mainframe!
