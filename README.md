
# IDL and VisXd Installation Guide for Linux

## 1. Installing Quickpic (and OSIRIS) using WSL on Local PC

### Quickpic Packages

#### 1.1 IDL

- **Use IDL versions** starting with 7 (Version 8 may not work).
- A working version can be found [here](https://golp2.tecnico.ulisboa.pt/nextcloud/index.php/s/MzEzqr8Kx4RnNcr). 
- **Important:** Download it directly into Linux and unzip it using:

    ```bash
    unzip dir_name
    ```

    **Do not unzip in Windows!**

- Inside the unzipped `IDL` folder, run the following commands:

    ```bash
    mv idl71_license_standalone.dat license
    cd license
    mv idl71_license_standalone.dat idl_license.lic
    ```

- To install IDL:

    1. Return to the `IDL` directory and run:

        ```bash
        ./install
        ```

    2. If you installed it in `/usr/local`, you may need to give executable permissions with:

        ```bash
        chmod +x install
        ```

    3. During installation, accept all options **except DICOM**.

- To check if `libXpm` is installed, run:

    ```bash
    sudo dpkg -S libXpm
    ```

    If it's missing, install it:

    ```bash
    sudo apt-get install libxpm4
    ```

    Then, create a symbolic link:

    ```bash
    cd /usr/lib/x86_64-linux-gnu
    sudo ln -s libXpm.so.4.11.0 /usr/lib/x86_64-linux-gnu/libXp.so.6
    ```

- Modify your `.bashrc`:

    ```bash
    nano ~/.bashrc
    ```

    Add the relevant IDL flags (see the `Bashrc` section below), then reload `.bashrc`:

    ```bash
    source ~/.bashrc
    ```

- Test the installation by typing `idl` in your terminal. If it displays something like this:

    ```
    IDL Version 7.1.1 (linux x86_64 m64). (c) 2009 ITT Visual Information Solutions
    Installation number: 2013321.
    Licensed for use by: TEAM TBE
    IDL>
    ```

    The installation was successful.

- If it didn’t work, activate the IDL license by running:

    ```bash
    cd /idl71/bin
    ./setup.bash
    ```

    Then try again.

#### 1.2 VisXd

- Download a package like `visxd-38b1c60983c33c9d4a1a64f3944c8f6be54308d3.zip` and **unzip it inside WSL**:

    ```bash
    unzip visxd-xxxx.zip
    ```

    **Do not unzip in Windows and copy into Linux**.

- Ensure you have a working X interface (this is automatic with WSL version 2). Test with:

    ```bash
    xeyes
    ```

    If you see a window, you're good to go. If not, try:

    ```bash
    export DISPLAY=:0
    ```

    To make this permanent, add it to your `.bashrc`.

- Test VisXd by running:

    ```bash
    idl vis2d
    ```

    A window should pop up if installed correctly.

## 2. Updating `.bashrc`

### Example `.bashrc` for VisXd

```bash
# Variables for VisXd (update paths accordingly)
export IDL_DIR="/home/username/path/to/IDL/idl71"
export IDL_PATH="<IDL_DEFAULT>:+/home/username/path/to/visxd"
export PATH="/home/username/path/to/IDL/idl71/bin:$PATH"
export PATH="/home/username/path/to/visxd/bin:$PATH"
export DISPLAY=:0

# Extra exports (not needed for IDL and VisXd)
export FCFLAGS="-I/usr/local/jsonfortran-gnu-6.3.0/lib"
export LDFLAGS="-L/usr/local/jsonfortran-gnu-6.3.0/lib -ljsonfortran"
export PATH=/usr/local/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/hdf5/lib:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=1
```

After making changes, update the file with:

```bash
source ~/.bashrc
```

## 3. Installing Quickpic

### 3.1 Prerequisites

- **GCC, GFortran, and MPI** are already installed.
- To install HDF5:

    ```bash
    git clone https://github.com/HDFGroup/hdf5.git
    cd hdf5
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$HOME/hdf5-install -DBUILD_SHARED_LIBS=ON -DHDF5_BUILD_FORTRAN=ON -DHDF5_ENABLE_PARALLEL=ON ..
    make -j$(nproc)
    make install
    ```

### 3.2 Installing JSON-Fortran

- To install JSON-Fortran:

    ```bash
    git clone https://github.com/jacobwilliams/json-fortran.git
    cd json-fortran
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$HOME/json-fortran-install ~/json-fortran
    make install
    ```

### 3.3 Updating Paths in `.bashrc`

```bash
# HDF5 Paths
export PATH=$HOME/hdf5-install/bin:$PATH
export LD_LIBRARY_PATH=$HOME/hdf5-install/lib:$LD_LIBRARY_PATH
export HDF5_INCLUDE_DIR="$HOME/hdf5-install/include"
export HDF5_LIB_DIR="$HOME/hdf5-install/lib"

# JSON-Fortran Paths
export FC=gfortran
export FCFLAGS="-I$HOME/json-fortran-install/jsonfortran-gnu-6.3.0/lib"
export LDFLAGS="-L$HOME/json-fortran-install/jsonfortran-gnu-6.3.0/lib -ljsonfortran"
export LD_LIBRARY_PATH=/data/username/json-fortran-install/jsonfortran-gnu-6.3.0/lib:$LD_LIBRARY_PATH
```

## 4. Updating the Makefile for Quick-PIC

- In `Quick-PIC/source`, open `make.GF_OPENMPI`. Update the following variables to point to your local paths:

    ```bash
    JSON_LIB, JSON_INC, HDF5_LIB, HDF5_INC
    ```

    Ensure to add `/data/username/` before every path.

- After updating, go to `/source` and run:

    ```bash
    make
    ```

    If there are no errors, the installation is complete.

## 5. Testing Quick-PIC

- Inside the `source/` directory, if the file `qpic.e` exists, move it:

    ```bash
    mv qpic.e /data/username/QuickPIC-OpenSource/input_file/laptop
    ```

- After defining `OMP_NUM_THREADS=1` in `.bashrc`, run the demo:

    ```bash
    mpirun -np 4 ./qpic.e
    ```

---

**End of Guide**
