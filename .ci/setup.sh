#!/bin/bash

set -e -E -u -o pipefail

rm -rf /Users/runner/hostedtoolcache
sudo rm -rf /Library/Java/JavaVirtualMachines/*

brew install cmake swig libomp
brew reinstall openjdk
export PATH="/usr/local/opt/openjdk/bin:$PATH"
ls /opt/homebrew/opt/openjdk/libexec/openjdk.jdk
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

#export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/include"
export CFLAGS="-I/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/include"
export LDFLAGS="-I/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/include"

git clone --recursive https://github.com/microsoft/LightGBM
cd LightGBM
cmake -B build -S . -DUSE_SWIG=ON
cmake --build build -j4

ls

echo "---"

ls ./build

#cd "./examples/regression/"
#"../../lightgbm" config="train.conf"

# if [[ $OS_NAME == "macos" ]]; then
#     if  [[ $COMPILER == "clang" ]]; then
#         brew install libomp
#         if [[ $AZURE == "true" ]]; then
#             sudo xcode-select -s /Applications/Xcode_13.1.0.app/Contents/Developer || exit 1
#         fi
#     else  # gcc
#         # Check https://github.com/actions/runner-images/tree/main/images/macos for available
#         # versions of Xcode
#         sudo xcode-select -s /Applications/Xcode_14.3.1.app/Contents/Developer || exit 1
#         brew install 'gcc@12'
#     fi
#     if [[ $TASK == "mpi" ]]; then
#         brew install open-mpi
#     fi
#     if [[ $TASK == "swig" ]]; then
#         brew install swig
#     fi
# else  # Linux
#     if type -f apt 2>&1 > /dev/null; then
#         sudo apt-get update
#         sudo apt-get install --no-install-recommends -y \
#             ca-certificates \
#             curl
#     else
#         sudo yum update -y
#         sudo yum install -y \
#             ca-certificates \
#             curl
#     fi
#     CMAKE_VERSION="3.30.0"
#     curl -O -L \
#         https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${ARCH}.sh \
#     || exit 1
#     sudo mkdir /opt/cmake || exit 1
#     sudo sh cmake-${CMAKE_VERSION}-linux-${ARCH}.sh --skip-license --prefix=/opt/cmake || exit 1
#     sudo ln -sf /opt/cmake/bin/cmake /usr/local/bin/cmake || exit 1

#     if [[ $IN_UBUNTU_BASE_CONTAINER == "true" ]]; then
#         # fixes error "unable to initialize frontend: Dialog"
#         # https://github.com/moby/moby/issues/27988#issuecomment-462809153
#         echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

#         sudo apt-get update
#         sudo apt-get install --no-install-recommends -y \
#             software-properties-common

#         sudo apt-get install --no-install-recommends -y \
#             build-essential \
#             git \
#             libcurl4 \
#             libicu-dev \
#             libssl-dev \
#             locales \
#             locales-all || exit 1
#         if [[ $COMPILER == "clang" ]]; then
#             sudo apt-get install --no-install-recommends -y \
#                 clang \
#                 libomp-dev
#         elif [[ $COMPILER == "clang-17" ]]; then
#             sudo apt-get install --no-install-recommends -y \
#                 wget
#             wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
#             sudo apt-add-repository deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main
#             sudo apt-add-repository deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main
#             sudo apt-get update
#             sudo apt-get install -y \
#                 clang-17 \
#                 libomp-17-dev
#         fi

#         export LANG="en_US.UTF-8"
#         sudo update-locale LANG=${LANG}
#         export LC_ALL="${LANG}"
#     fi
#     if [[ $TASK == "r-package" ]] && [[ $COMPILER == "clang" ]]; then
#         sudo apt-get install --no-install-recommends -y \
#             libomp-dev
#     fi
#     if [[ $TASK == "mpi" ]]; then
#         if [[ $IN_UBUNTU_BASE_CONTAINER == "true" ]]; then
#             sudo apt-get update
#             sudo apt-get install --no-install-recommends -y \
#                 libopenmpi-dev \
#                 openmpi-bin
#         else  # in manylinux image
#             sudo yum update -y
#             sudo yum install -y \
#                 openmpi-devel \
#             || exit 1
#         fi
#     fi
#     if [[ $TASK == "gpu" ]]; then
#         if [[ $IN_UBUNTU_BASE_CONTAINER == "true" ]]; then
#             sudo apt-get update
#             sudo apt-get install --no-install-recommends -y \
#                 libboost1.74-dev \
#                 libboost-filesystem1.74-dev \
#                 ocl-icd-opencl-dev
#         else  # in manylinux image
#             sudo yum update -y
#             sudo yum install -y \
#                 boost-devel \
#                 ocl-icd-devel \
#                 opencl-headers \
#             || exit 1
#         fi
#     fi
#     if [[ $TASK == "gpu" || $TASK == "bdist" ]]; then
#         if [[ $IN_UBUNTU_BASE_CONTAINER == "true" ]]; then
#             sudo apt-get update
#             sudo apt-get install --no-install-recommends -y \
#                 pocl-opencl-icd
#         elif [[ $(uname -m) == "x86_64" ]]; then
#             sudo yum update -y
#             sudo yum install -y \
#                 ocl-icd-devel \
#                 opencl-headers \
#             || exit 1
#         fi
#     fi
#     if [[ $TASK == "cuda" ]]; then
#         echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
#         if [[ $COMPILER == "clang" ]]; then
#             apt-get update
#             apt-get install --no-install-recommends -y \
#                 clang \
#                 libomp-dev
#         fi
#     fi
# fi
