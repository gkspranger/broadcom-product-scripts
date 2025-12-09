#!/usr/bin/env bash

# convert declared Python version (3.12.10) to formatted version (v3r12)
__PYTHON_VERSION=$(cat .python-version | xargs)
__MAJOR_MINOR="${__PYTHON_VERSION%.*}"
__FORMATTED_VERSION="v${__MAJOR_MINOR/./r}"

# use common IBM Python path and formatted version to define PYTHONHOME
__PYTHON_ROOT="/usr/lpp/IBM/cyp"
PYTHONHOME="$__PYTHON_ROOT/$__FORMATTED_VERSION/pyz"

# use PYTHONHOME to update PATH and LIBPATH paths
export PATH="$PYTHONHOME/bin:$PATH"
export LIBPATH="$PYTHONHOME/lib:$LIBPATH"

# protect project from installed system site-packages
unset PYTHONUSERBASE
unset PYTHONPATH

# define required IBM Python environment variables
export _BPXK_AUTOCVT="ON"
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN="txt"
export _TAG_REDIR_OUT="txt"
export _TAG_REDIR_ERR="txt"

# display Python and Pip version
python --version
pip --version

# setup virtual environment, if it doesn't exist
if [[ -d .venv ]]; then
  true
else
  python -m venv .venv
fi

# define path to Python binary
__PYTHON_BINARY=".venv/bin/python"

# don't lookup packages in a PYPI index, packages are local
export PIP_NO_INDEX=1
# only install wheel files
export PIP_ONLY_BINARY=":all:"

# generic header
header() {
  echo """
##############################
## $1
##############################
"""
}

# setup environment for developing/building
setup() {
  header "setup project"

  # install project dependencies
  $__PYTHON_BINARY -m pip install -e .[test]
}

# build artifacts
build() {
  header "build project"

  # install build dependencies
  $__PYTHON_BINARY -m pip install build

  # build wheel file
  $__PYTHON_BINARY -m build --wheel
}

# test code
test() {
  header "test project"

  # execute test runner
  $__PYTHON_BINARY -m tox
}

# install wheel distribution
install() {
  header "install project"

  # install all to target directory
  $__PYTHON_BINARY -m pip install dist/*.whl -t build-out/artifact
}

# assemble artifacts
assemble() {
  header "assemble project"

  # create artifact to be published
  cd build-out/artifact
  pax -wz -x pax -f ../artifact.pax.Z ./
}

# create protective wrapper script for every [project.script]
protect() {
  header "protect project"

  for i in $(find build-out/artifact/bin -type f); do
    cat <<EOF > $i.wrapped
#!/usr/bin/env bash
PYTHONHOME="/usr/lpp/IBM/cyp/$__FORMATTED_VERSION/pyz"
export PATH="\$PYTHONHOME/bin:\$PATH"
export LIBPATH="\$PYTHONHOME/lib:\$LIBPATH"

export _BPXK_AUTOCVT="ON"
export _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
export _TAG_REDIR_IN="txt"
export _TAG_REDIR_OUT="txt"
export _TAG_REDIR_ERR="txt"

unset PYTHONUSERBASE

export __SCRIPT_DIR="\$(cd \$(dirname \$0); echo \$PWD)"
export PYTHONPATH="\$(dirname \$__SCRIPT_DIR)"

export __SCRIPT_NAME="\$(basename \$0)"
export __SCRIPT_ORIG="\$(echo \$__SCRIPT_NAME | sed 's/\.wrapped$//')"

exec python \$__SCRIPT_DIR/\$__SCRIPT_ORIG "\$@"
EOF
    chmod 755 $i.wrapped
  done
}

case "$1" in
  build)
    setup
    build
    test
    install
    protect
    assemble
    ;;
  *)
    echo "Unknown command: $1"
    echo "Available commands: build"
    exit 1
    ;;
esac
