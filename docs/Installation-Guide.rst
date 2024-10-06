Installation Guide
==================

All instructions below are aimed at compiling the 64-bit version of LightGBM.
It is worth compiling the 32-bit version only in very rare special cases involving environmental limitations.
The 32-bit version is slow and untested, so use it at your own risk and don't forget to adjust some of the commands below when installing.

By default, instructions below will produce a shared library file and an executable file with command-line interface.
You can add ``-DBUILD_CLI=OFF`` to CMake flags to disable the executable compilation.

If you need to build a static library instead of a shared one, you can add ``-DBUILD_STATIC_LIB=ON`` to CMake flags.

By default, instructions below will place header files into system-wide folder.
You can add ``-DINSTALL_HEADERS=OFF`` to CMake flags to disable headers installation.

By default, on macOS, CMake is looking into Homebrew standard folders for finding dependencies (e.g. OpenMP).
You can add ``-DUSE_HOMEBREW_FALLBACK=OFF`` to CMake flags to disable this behaviour.

Users who want to perform benchmarking can make LightGBM output time costs for different internal routines by adding ``-DUSE_TIMETAG=ON`` to CMake flags.

It is possible to build LightGBM in debug mode. In this mode all compiler optimizations are disabled and LightGBM performs more checks internally. To enable debug mode you can add ``-DUSE_DEBUG=ON`` to CMake flags or choose ``Debug_*`` configuration (e.g. ``Debug_DLL``, ``Debug_mpi``) in Visual Studio depending on how you are building LightGBM.

.. _sanitizers:

In addition to the debug mode, LightGBM can be built with compiler sanitizers.
To enable them add ``-DUSE_SANITIZER=ON -DENABLED_SANITIZERS="address;leak;undefined"`` to CMake flags.
These values refer to the following supported sanitizers:

- ``address`` - AddressSanitizer (ASan);
- ``leak`` - LeakSanitizer (LSan);
- ``undefined`` - UndefinedBehaviorSanitizer (UBSan);
- ``thread`` - ThreadSanitizer (TSan).

Please note, that ThreadSanitizer cannot be used together with other sanitizers.
For more info and additional sanitizers' parameters please refer to the `following docs`_.
It is very useful to build `C++ unit tests <#build-c-unit-tests>`__ with sanitizers.

.. _nightly-builds:

You can download the artifacts of the latest successful build on master branch (nightly builds) here: |download artifacts|.

.. contents:: **Contents**
    :depth: 1
    :local:
    :backlinks: none

Windows
~~~~~~~

On Windows LightGBM can be built using

- **Visual Studio**;

- **CMake** and **VS Build Tools**;

- **CMake** and **MinGW**;

- **CMake**, **MinGW** and **Ninja**.

Visual Studio (or VS Build Tools)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

With GUI
********

1. Install `Visual Studio`_.

2. Navigate to one of the releases at https://github.com/microsoft/LightGBM/releases, download ``LightGBM-complete_source_code_zip.zip``, and unzip it.

3. Go to ``LightGBM-complete_source_code_zip/windows`` folder.

4. Open ``LightGBM.sln`` file with **Visual Studio**, choose ``Release`` configuration if you need executable file or ``DLL`` configuration if you need shared library and click ``Build`` -> ``Build Solution (Ctrl+Shift+B)``.

   If you have errors about **Platform Toolset**, go to ``Project`` -> ``Properties`` -> ``Configuration Properties`` -> ``General`` and select the toolset installed on your machine.

The ``.exe`` file will be in ``LightGBM-complete_source_code_zip/windows/x64/Release`` folder.
The ``.dll`` file will be in ``LightGBM-complete_source_code_zip/windows/x64/DLL`` folder.

From Command Line
*****************

1. Install `Git for Windows`_, `CMake`_ and `VS Build Tools`_ (**VS Build Tools** is not needed if **Visual Studio** is already installed).

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -A x64
     cmake --build build --target ALL_BUILD --config Release

The ``.exe`` and ``.dll`` files will be in ``LightGBM/Release`` folder.

MinGW-w64
^^^^^^^^^

1. Install `Git for Windows`_, `CMake`_ and `MinGW-w64`_.

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G "MinGW Makefiles"
     cmake --build build -j4

The ``.exe`` and ``.dll`` files will be in ``LightGBM/`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G "MinGW Makefiles"`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.

It is recommended that you use **Visual Studio** since it has better multithreading efficiency in **Windows** for many-core systems
(see `Question 4 <./FAQ.rst#i-am-using-windows-should-i-use-visual-studio-or-mingw-for-compiling-lightgbm>`__ and `Question 8 <./FAQ.rst#cpu-usage-is-low-like-10-in-windows-when-using-lightgbm-on-very-large-datasets-with-many-core-systems>`__).

MinGW-w64 and Ninja
^^^^^^^^^^^^^^^^^^^

1. Install `Git for Windows`_, `CMake`_, `MinGW-w64`_ and `Ninja`_.

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G Ninja
     cmake --build build -j4

The ``.exe`` and ``.dll`` files will be in ``LightGBM/`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G Ninja`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.

It is recommended that you use **Visual Studio** since it has better multithreading efficiency in **Windows** for many-core systems
(see `Question 4 <./FAQ.rst#i-am-using-windows-should-i-use-visual-studio-or-mingw-for-compiling-lightgbm>`__ and `Question 8 <./FAQ.rst#cpu-usage-is-low-like-10-in-windows-when-using-lightgbm-on-very-large-datasets-with-many-core-systems>`__).

Linux
~~~~~

On Linux LightGBM can be built using **CMake** and **gcc** or **Clang**.

1. Install `CMake`_.

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S .
     cmake --build build -j4

**Note**: In some rare cases you may need to install OpenMP runtime library separately (use your package manager and search for ``lib[g|i]omp`` for doing this).

Using ``Ninja``
^^^^^^^^^^^^^^^

On Linux, LightGBM can also be built with `Ninja`_ instead of ``make``.

.. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G 'Ninja'
     cmake --build build -j2

macOS
~~~~~

On macOS LightGBM can be installed using **Homebrew**, **MacPorts**, or can be built using

- **CMake** and **Apple Clang**;

- **CMake**, **Ninja** and **Apple Clang**;

- **CMake** and **gcc**;

- **CMake**, **Ninja** and **gcc**.

Install Using ``Homebrew``
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: sh

  brew install lightgbm

Refer to https://formulae.brew.sh/formula/lightgbm for more details.

Install Using ``MacPorts``
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: sh

  sudo port install LightGBM

Refer to https://ports.macports.org/port/LightGBM for more details.

**Note**: Port for LightGBM is not maintained by LightGBM's maintainers.

Build from GitHub
^^^^^^^^^^^^^^^^^

Apple Clang
***********

1. Install `CMake`_ and **OpenMP**:

   .. code:: sh

     brew install cmake libomp

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S .
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

Apple Clang and Ninja
*********************

1. Install `CMake`_, **OpenMP** and `Ninja`_:

   .. code:: sh

     brew install cmake libomp ninja

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G Ninja
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

gcc
***

1. Install `CMake`_ and **gcc**:

   .. code:: sh

     brew install cmake gcc

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     export CXX=g++-7 CC=gcc-7  # replace "7" with version of gcc installed on your machine
     cmake -B build -S .
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

gcc and Ninja
*************

1. Install `CMake`_, **gcc** and `Ninja`_:

   .. code:: sh

     brew install cmake gcc ninja

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     export CXX=g++-7 CC=gcc-7  # replace "7" with version of gcc installed on your machine
     cmake -B build -S . -G Ninja
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

Docker
~~~~~~

Refer to `Docker folder <https://github.com/microsoft/LightGBM/tree/master/docker>`__.

Build Threadless Version (not Recommended)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The default build version of LightGBM is based on OpenMP.
You can build LightGBM without OpenMP support but it is **strongly not recommended**.

Windows
^^^^^^^

On Windows a version of LightGBM without OpenMP support can be built using

- **Visual Studio**;

- **CMake** and **VS Build Tools**;

- **CMake** and **MinGW**;

- **CMake**, **MinGW** and **Ninja**.

Visual Studio (or VS Build Tools)
*********************************

With GUI
--------

1. Install `Visual Studio`_.

2. Navigate to one of the releases at https://github.com/microsoft/LightGBM/releases, download ``LightGBM-complete_source_code_zip.zip``, and unzip it.

3. Go to ``LightGBM-complete_source_code_zip/windows`` folder.

4. Open ``LightGBM.sln`` file with **Visual Studio**, choose ``Release`` configuration if you need executable file or ``DLL`` configuration if you need shared library.

5. Go to ``Project`` -> ``Properties`` -> ``Configuration Properties`` -> ``C/C++`` -> ``Language`` and change the ``OpenMP Support`` property to ``No (/openmp-)``.

6. Get back to the project's main screen and click ``Build`` -> ``Build Solution (Ctrl+Shift+B)``.

   If you have errors about **Platform Toolset**, go to ``Project`` -> ``Properties`` -> ``Configuration Properties`` -> ``General`` and select the toolset installed on your machine.

The ``.exe`` file will be in ``LightGBM-complete_source_code_zip/windows/x64/Release`` folder.
The ``.dll`` file will be in ``LightGBM-complete_source_code_zip/windows/x64/DLL`` folder.

From Command Line
-----------------

1. Install `Git for Windows`_, `CMake`_ and `VS Build Tools`_ (**VS Build Tools** is not needed if **Visual Studio** is already installed).

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -A x64 -DUSE_OPENMP=OFF
     cmake --build build --target ALL_BUILD --config Release

The ``.exe`` and ``.dll`` files will be in ``LightGBM/Release`` folder.

MinGW-w64
*********

1. Install `Git for Windows`_, `CMake`_ and `MinGW-w64`_.

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G "MinGW Makefiles" -DUSE_OPENMP=OFF
     cmake --build build -j4

The ``.exe`` and ``.dll`` files will be in ``LightGBM/`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G "MinGW Makefiles" -DUSE_OPENMP=OFF`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.

MinGW-w64 and Ninja
*******************

1. Install `Git for Windows`_, `CMake`_, `MinGW-w64`_ and `Ninja`_.

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G Ninja -DUSE_OPENMP=OFF
     cmake --build build -j4

The ``.exe`` and ``.dll`` files will be in ``LightGBM/`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G Ninja -DUSE_OPENMP=OFF`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.


Linux
^^^^^

On Linux a version of LightGBM without OpenMP support can be built using **CMake** and **gcc** or **Clang**.

1. Install `CMake`_.

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DUSE_OPENMP=OFF
     cmake --build build -j4

macOS
^^^^^

On macOS a version of LightGBM without OpenMP support can be built using

- **CMake** and **Apple Clang**;

- **CMake**, **Ninja** and **Apple Clang**;

- **CMake** and **gcc**;

- **CMake**, **Ninja** and **gcc**.

Apple Clang
***********

1. Install `CMake`_:

   .. code:: sh

     brew install cmake

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DUSE_OPENMP=OFF
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

Apple Clang and Ninja
*********************

1. Install `CMake`_ and `Ninja`_:

   .. code:: sh

     brew install cmake ninja

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DUSE_OPENMP=OFF -G Ninja
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

gcc
***

1. Install `CMake`_ and **gcc**:

   .. code:: sh

     brew install cmake gcc

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     export CXX=g++-7 CC=gcc-7  # replace "7" with version of gcc installed on your machine
     cmake -B build -S . -DUSE_OPENMP=OFF
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

gcc and Ninja
*************

1. Install `CMake`_, **gcc** and `Ninja`_:

   .. code:: sh

     brew install cmake gcc ninja

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     export CXX=g++-7 CC=gcc-7  # replace "7" with version of gcc installed on your machine
     cmake -B build -S . -DUSE_OPENMP=OFF -G Ninja
     cmake --build build -j4

The executable and ``.dylib`` files will be in LightGBM/ folder.

Build MPI Version
~~~~~~~~~~~~~~~~~

The default build version of LightGBM is based on socket. LightGBM also supports MPI.
`MPI`_ is a high performance communication approach with `RDMA`_ support.

If you need to run a distributed learning application with high performance communication, you can build the LightGBM with MPI support.

Windows
^^^^^^^

On Windows an MPI version of LightGBM can be built using

- **MS MPI** and **Visual Studio**;

- **MS MPI**, **CMake** and **VS Build Tools**.

**Note**: Building MPI version by **MinGW** is not supported due to the miss of MPI library in it.

With GUI
********

1. You need to install `MS MPI`_ first. Both ``msmpisdk.msi`` and ``msmpisetup.exe`` are needed.

2. Install `Visual Studio`_.

3. Navigate to one of the releases at https://github.com/microsoft/LightGBM/releases, download ``LightGBM-complete_source_code_zip.zip``, and unzip it.

4. Go to ``LightGBM-complete_source_code_zip/windows`` folder.

5. Open ``LightGBM.sln`` file with **Visual Studio**, choose ``Release_mpi`` configuration and click ``Build`` -> ``Build Solution (Ctrl+Shift+B)``.

   If you have errors about **Platform Toolset**, go to ``Project`` -> ``Properties`` -> ``Configuration Properties`` -> ``General`` and select the toolset installed on your machine.

The ``.exe`` file will be in ``LightGBM-complete_source_code_zip/windows/x64/Release_mpi`` folder.

From Command Line
*****************

1. You need to install `MS MPI`_ first. Both ``msmpisdk.msi`` and ``msmpisetup.exe`` are needed.

2. Install `Git for Windows`_, `CMake`_ and `VS Build Tools`_ (**VS Build Tools** is not needed if **Visual Studio** is already installed).

3. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -A x64 -DUSE_MPI=ON
     cmake --build build --target ALL_BUILD --config Release

The ``.exe`` and ``.dll`` files will be in ``LightGBM/Release`` folder.

Linux
^^^^^

On Linux an MPI version of LightGBM can be built using **Open MPI**, **CMake** and **gcc** or **Clang**.

1. Install `Open MPI`_.

2. Install `CMake`_.

3. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DUSE_MPI=ON
     cmake --build build -j4

**Note**: In some rare cases you may need to install OpenMP runtime library separately (use your package manager and search for ``lib[g|i]omp`` for doing this).

macOS
^^^^^

On macOS an MPI version of LightGBM can be built using **Open MPI**, **CMake** and **Apple Clang** or **gcc**.

Apple Clang
***********

Only **Apple Clang** version 8.1 or higher is supported.

1. Install `CMake`_ :

   .. code:: sh

     brew install cmake

2. Install **OpenMP**:

   .. code:: sh

     brew install libomp

3. Install **Open MPI**:

   .. code:: sh

     brew install open-mpi

4. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DUSE_MPI=ON
     cmake --build build -j4

gcc
***

1. Install `CMake`_ :

   .. code:: sh

     brew install cmake

2. Install **gcc**:

   .. code:: sh

     brew install gcc

3. Install **Open MPI**:

   .. code:: sh

     brew install open-mpi

4. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     export CXX=g++-7 CC=gcc-7  # replace "7" with version of gcc installed on your machine
     cmake -B build -S . -DUSE_MPI=ON
     cmake --build build -j4

Build GPU Version
~~~~~~~~~~~~~~~~~

Windows
^^^^^^^

On Windows a GPU version of LightGBM (``device_type=gpu``) can be built using

- **OpenCL**, **Boost**, **CMake** and **VS Build Tools**;

- **OpenCL**, **Boost**, **CMake** and **MinGW**;

- **OpenCL**, **Boost**, **CMake**, **MinGW** and **Ninja**.

If you use **MinGW**, the build procedure is similar to the build on Linux.

Following procedure is for the **MSVC** (Microsoft Visual C++) build.

1. Install `Git for Windows`_, `CMake`_ and `VS Build Tools`_ (**VS Build Tools** is not needed if **Visual Studio** is installed).

2. Install **OpenCL** for Windows. The installation depends on the brand (NVIDIA, AMD, Intel) of your GPU card.

   - For running on Intel, get `Intel SDK for OpenCL`_.

   - For running on AMD, get AMD APP SDK.

   - For running on NVIDIA, get `CUDA Toolkit`_.

   Further reading and correspondence table: `GPU SDK Correspondence and Device Targeting Table <./GPU-Targets.rst>`__.

3. Install `Boost Binaries`_.

   **Note**: Match your Visual C++ version:

   Visual Studio 2015 -> ``msvc-14.0-64.exe``,

   Visual Studio 2017 -> ``msvc-14.1-64.exe``,

   Visual Studio 2019 -> ``msvc-14.2-64.exe``,

   Visual Studio 2022 -> ``msvc-14.3-64.exe``.

4. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -A x64 -DUSE_GPU=ON -DBOOST_ROOT=C:/local/boost_1_63_0 -DBOOST_LIBRARYDIR=C:/local/boost_1_63_0/lib64-msvc-14.0
     # if you have installed NVIDIA CUDA to a customized location, you should specify paths to OpenCL headers and library like the following:
     # cmake -B build -S . -A x64 -DUSE_GPU=ON -DBOOST_ROOT=C:/local/boost_1_63_0 -DBOOST_LIBRARYDIR=C:/local/boost_1_63_0/lib64-msvc-14.0 -DOpenCL_LIBRARY="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v10.0/lib/x64/OpenCL.lib" -DOpenCL_INCLUDE_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v10.0/include"
     cmake --build build --target ALL_BUILD --config Release

   **Note**: ``C:/local/boost_1_63_0`` and ``C:/local/boost_1_63_0/lib64-msvc-14.0`` are locations of your **Boost** binaries (assuming you've downloaded 1.63.0 version for Visual Studio 2015).

The ``.exe`` and ``.dll`` files will be in ``LightGBM/Release`` folder.

Linux
^^^^^

On Linux a GPU version of LightGBM (``device_type=gpu``) can be built using **OpenCL**, **Boost**, **CMake** and **gcc** or **Clang**.

The following dependencies should be installed before compilation:

-  **OpenCL** 1.2 headers and libraries, which is usually provided by GPU manufacture.

   The generic OpenCL ICD packages (for example, Debian package ``ocl-icd-libopencl1`` and ``ocl-icd-opencl-dev``) can also be used.

-  **libboost** 1.56 or later (1.61 or later is recommended).

   We use Boost.Compute as the interface to GPU, which is part of the Boost library since version 1.61. However, since we include the source code of Boost.Compute as a submodule, we only require the host has Boost 1.56 or later installed. We also use Boost.Align for memory allocation. Boost.Compute requires Boost.System and Boost.Filesystem to store offline kernel cache.

   The following Debian packages should provide necessary Boost libraries: ``libboost-dev``, ``libboost-system-dev``, ``libboost-filesystem-dev``.

-  **CMake**

To build LightGBM GPU version, run the following commands:

.. code:: sh

  git clone --recursive https://github.com/microsoft/LightGBM
  cd LightGBM
  cmake -B build -S . -DUSE_GPU=ON
  # if you have installed NVIDIA CUDA to a customized location, you should specify paths to OpenCL headers and library like the following:
  # cmake -B build -S . -DUSE_GPU=ON -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/
  cmake --build build

**Note**: In some rare cases you may need to install OpenMP runtime library separately (use your package manager and search for ``lib[g|i]omp`` for doing this).

macOS
^^^^^

The GPU version is not supported on macOS.

Docker
^^^^^^

Refer to `GPU Docker folder <https://github.com/microsoft/LightGBM/tree/master/docker/gpu>`__.

Build CUDA Version
~~~~~~~~~~~~~~~~~~

The `original GPU build <#build-gpu-version>`__ of LightGBM (``device_type=gpu``) is based on OpenCL.

The CUDA-based build (``device_type=cuda``) is a separate implementation.
Use this version in Linux environments with an NVIDIA GPU with compute capability 6.0 or higher.

Windows
^^^^^^^

The CUDA version is not supported on Windows.
Use the `GPU version <#build-gpu-version>`__ (``device_type=gpu``) for GPU acceleration on Windows.

Linux
^^^^^

On Linux a CUDA version of LightGBM can be built using **CUDA**, **CMake** and **gcc** or **Clang**.

The following dependencies should be installed before compilation:

-  **CUDA** 11.0 or later libraries. Please refer to `this detailed guide`_. Pay great attention to the minimum required versions of host compilers listed in the table from that guide and use only recommended versions of compilers.

-  **CMake**

To build LightGBM CUDA version, run the following commands:

.. code:: sh

  git clone --recursive https://github.com/microsoft/LightGBM
  cd LightGBM
  cmake -B build -S . -DUSE_CUDA=ON
  cmake --build build -j4

**Note**: In some rare cases you may need to install OpenMP runtime library separately (use your package manager and search for ``lib[g|i]omp`` for doing this).

macOS
^^^^^

The CUDA version is not supported on macOS.

Build Java Wrapper
~~~~~~~~~~~~~~~~~~

Using the following instructions you can generate a JAR file containing the LightGBM `C API <./Development-Guide.rst#c-api>`__ wrapped by **SWIG**.

Windows
^^^^^^^

On Windows a Java wrapper of LightGBM can be built using

- **Java**, **SWIG**, **CMake** and **VS Build Tools**;

- **Java**, **SWIG**, **CMake** and **MinGW**;

- **Java**, **SWIG**, **CMake**, **MinGW** and **Ninja**.

VS Build Tools
**************

1. Install `Git for Windows`_, `CMake`_ and `VS Build Tools`_ (**VS Build Tools** is not needed if **Visual Studio** is already installed).

2. Install `SWIG`_ and **Java** (also make sure that ``JAVA_HOME`` environment variable is set properly).

3. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -A x64 -DUSE_SWIG=ON
     cmake --build build --target ALL_BUILD --config Release

The ``.jar`` file will be in ``LightGBM/build`` folder.

MinGW-w64
*********

1. Install `Git for Windows`_, `CMake`_ and `MinGW-w64`_.

2. Install `SWIG`_ and **Java** (also make sure that ``JAVA_HOME`` environment variable is set properly).

3. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G "MinGW Makefiles" -DUSE_SWIG=ON
     cmake --build build -j4

The ``.jar`` file will be in ``LightGBM/build`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G "MinGW Makefiles" -DUSE_SWIG=ON`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.

It is recommended to use **VS Build Tools (Visual Studio)** since it has better multithreading efficiency in **Windows** for many-core systems
(see `Question 4 <./FAQ.rst#i-am-using-windows-should-i-use-visual-studio-or-mingw-for-compiling-lightgbm>`__ and `Question 8 <./FAQ.rst#cpu-usage-is-low-like-10-in-windows-when-using-lightgbm-on-very-large-datasets-with-many-core-systems>`__).

MinGW-w64 and Ninja
*******************

1. Install `Git for Windows`_, `CMake`_, `MinGW-w64`_ and `Ninja`_.

2. Install `SWIG`_ and **Java** (also make sure that ``JAVA_HOME`` environment variable is set properly).

3. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G Ninja -DUSE_SWIG=ON
     cmake --build build -j4

The ``.jar`` file will be in ``LightGBM/build`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G Ninja -DUSE_SWIG=ON`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.

It is recommended to use **VS Build Tools (Visual Studio)** since it has better multithreading efficiency in **Windows** for many-core systems
(see `Question 4 <./FAQ.rst#i-am-using-windows-should-i-use-visual-studio-or-mingw-for-compiling-lightgbm>`__ and `Question 8 <./FAQ.rst#cpu-usage-is-low-like-10-in-windows-when-using-lightgbm-on-very-large-datasets-with-many-core-systems>`__).

Linux
^^^^^

On Linux a Java wrapper of LightGBM can be built using **Java**, **SWIG**, **CMake** and **gcc** or **Clang**.

1. Install `CMake`_, `SWIG`_ and **Java** (also make sure that ``JAVA_HOME`` environment variable is set properly).

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DUSE_SWIG=ON
     cmake --build build -j4

**Note**: In some rare cases you may need to install OpenMP runtime library separately (use your package manager and search for ``lib[g|i]omp`` for doing this).

macOS
^^^^^

On macOS a Java wrapper of LightGBM can be built using **Java**, **SWIG**, **CMake** and **Apple Clang** or **gcc**.

First, install `SWIG`_ and **Java** (also make sure that ``JAVA_HOME`` environment variable is set properly).
Then, either follow the **Apple Clang** or **gcc** installation instructions below.

Apple Clang
***********

Only **Apple Clang** version 8.1 or higher is supported.

1. Install `CMake`_ :

   .. code:: sh

     brew install cmake

2. Install **OpenMP**:

   .. code:: sh

     brew install libomp

3. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DUSE_SWIG=ON
     cmake --build build -j4

gcc
***

1. Install `CMake`_ :

   .. code:: sh

     brew install cmake

2. Install **gcc**:

   .. code:: sh

     brew install gcc

3. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     export CXX=g++-7 CC=gcc-7  # replace "7" with version of gcc installed on your machine
     cmake -B build -S . -DUSE_SWIG=ON
     cmake --build build -j4

Build Python-package
~~~~~~~~~~~~~~~~~~~~

Refer to `Python-package folder <https://github.com/microsoft/LightGBM/tree/master/python-package>`__.

Build R-package
~~~~~~~~~~~~~~~

Refer to `R-package folder <https://github.com/microsoft/LightGBM/tree/master/R-package>`__.

Build C++ Unit Tests
~~~~~~~~~~~~~~~~~~~~

Windows
^^^^^^^

On Windows, C++ unit tests of LightGBM can be built using

- **CMake** and **VS Build Tools**;

- **CMake** and **MinGW**;

- **CMake**, **MinGW** and **Ninja**.

VS Build Tools
**************

1. Install `Git for Windows`_, `CMake`_ and `VS Build Tools`_ (**VS Build Tools** is not needed if **Visual Studio** is already installed).

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -A x64 -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF
     cmake --build build --target testlightgbm --config Debug

The ``.exe`` file will be in ``LightGBM/Debug`` folder.

MinGW-w64
*********

1. Install `Git for Windows`_, `CMake`_ and `MinGW-w64`_.

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G "MinGW Makefiles" -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF
     cmake --build build --target testlightgbm -j4

The ``.exe`` file will be in ``LightGBM/`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G "MinGW Makefiles" -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.

MinGW-w64 and Ninja
*******************

1. Install `Git for Windows`_, `CMake`_, `MinGW-w64`_ and `Ninja`_.

2. Run the following commands:

   .. code:: console

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -G Ninja -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF
     cmake --build build --target testlightgbm -j4

The ``.exe`` file will be in ``LightGBM/`` folder.

**Note**: You may need to run the ``cmake -B build -S . -G Ninja -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF`` one more time or add ``-DCMAKE_SH=CMAKE_SH-NOTFOUND`` to CMake flags if you encounter the ``sh.exe was found in your PATH`` error.

Linux
^^^^^

On Linux a C++ unit tests of LightGBM can be built using **CMake** and **gcc** or **Clang**.

1. Install `CMake`_.

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF
     cmake --build build --target testlightgbm -j4

macOS
^^^^^

On macOS a C++ unit tests of LightGBM can be built using **CMake** and **Apple Clang** or **gcc**.

Apple Clang
***********

Only **Apple Clang** version 8.1 or higher is supported.

1. Install `CMake`_ :

   .. code:: sh

     brew install cmake

2. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     cmake -B build -S . -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF
     cmake --build build --target testlightgbm -j4

gcc
***

1. Install `CMake`_ :

   .. code:: sh

     brew install cmake

2. Install **gcc**:

   .. code:: sh

     brew install gcc

3. Run the following commands:

   .. code:: sh

     git clone --recursive https://github.com/microsoft/LightGBM
     cd LightGBM
     export CXX=g++-7 CC=gcc-7  # replace "7" with version of gcc installed on your machine
     cmake -B build -S . -DBUILD_CPP_TEST=ON -DUSE_OPENMP=OFF
     cmake --build build --target testlightgbm -j4


.. |download artifacts| image:: ./_static/images/artifacts-not-available.svg
   :target: https://lightgbm.readthedocs.io/en/latest/Installation-Guide.html

.. _Visual Studio: https://visualstudio.microsoft.com/downloads/

.. _Git for Windows: https://git-scm.com/download/win

.. _CMake: https://cmake.org/

.. _VS Build Tools: https://visualstudio.microsoft.com/downloads/

.. _MinGW-w64: https://www.mingw-w64.org/downloads/

.. _MPI: https://en.wikipedia.org/wiki/Message_Passing_Interface

.. _RDMA: https://en.wikipedia.org/wiki/Remote_direct_memory_access

.. _MS MPI: https://learn.microsoft.com/en-us/message-passing-interface/microsoft-mpi-release-notes

.. _Open MPI: https://www.open-mpi.org/

.. _Intel SDK for OpenCL: https://software.intel.com/en-us/articles/opencl-drivers

.. _CUDA Toolkit: https://developer.nvidia.com/cuda-downloads

.. _Boost Binaries: https://sourceforge.net/projects/boost/files/boost-binaries/

.. _SWIG: https://www.swig.org/download.html

.. _this detailed guide: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html

.. _following docs: https://github.com/google/sanitizers/wiki

.. _Ninja: https://ninja-build.org
