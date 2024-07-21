#!/bin/bash
# This was made to work in CESGA HPC
# Download and install required library and data files for WRF.
# Run this script in the directory where you want to install the libraries.

source ~/.bashrc

## Directory Listing
# export HOME=`pwd`
cd $HOME
mkdir Downloads
mkdir libs


# Compilers
export DIR=$HOME/libs
# export CC=icx
# export CXX=icpx
# export FC=ifx
# export F77=ifx

# export CPP=icx
# export CXXCPP=icpx
# export F90=ifx

export CC=icc
export CXX=icpc
export FC=ifort
export F77=ifort



# Intel one API
cd $HOME
sudo bash l_HPCKit_p_2021.4.0.3347_offline.sh -a --silent --eula accept
source /opt/intel/oneapi/setvars.sh

# zlib
cd $HOME/Downloads
wget -c https://www2.mmm.ucar.edu/people/duda/files/mpas/sources/zlib-1.2.11.tar.gz
tar -xvzf zlib-1.2.11.tar.gz
cd zlib-1.2.11/
./configure --prefix=$DIR
make
make install


# hdf5 library for netcdf4 functionality
cd $HOME/Downloads
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
tar -xvzf hdf5-1.10.5.tar.gz
cd hdf5-1.10.5
./configure --prefix=$DIR --with-zlib=$DIR --enable-fortran --enable-shared
make
make install

export HDF5=$DIR
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH


## Install NETCDF C Library
cd $HOME/Downloads
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz
tar -xvzf v4.9.2.tar.gz
cd netcdf-c-4.9.2
export CPPFLAGS=-I$DIR/include 
export LDFLAGS=-L$DIR/lib
./configure --prefix=$DIR --enable-netcdf-4 #CFLAGS=-O3 CXXFLAGS=-O3 FFLAGS=-O3
make
make install

export PATH=$DIR/bin:$PATH
export NETCDF=$DIR


## NetCDF fortran library
cd $HOME/Downloads
wget -c https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.1.tar.gz
tar -xvzf v4.6.1.tar.gz
cd netcdf-fortran-4.6.1
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/include 
export LDFLAGS=-L$DIR/lib
export LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz" 
./configure --prefix=$DIR #CFLAGS=-O3 CXXFLAGS=-O3 FFLAGS=-O3
make
make install


## MPICH
cd $HOME/Downloads
wget -c http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz
tar -xvzf mpich-3.3.1.tar.gz
cd mpich-3.3.1/
./configure --prefix=$DIR
make
make install

export PATH=$DIR/bin:$PATH


# libpng
cd $HOME/Downloads
wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37/
./configure --prefix=$DIR
make
make install

# JasPer
cd $HOME/Downloads
wget -c https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
tar -xvzf jasper-1.900.1.tar.gz
cd jasper-1.900.1/
autoreconf -i
./configure --prefix=$DIR
make
make install
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include



# # Libs
# export PATH=$DIR/bin:$DIR/netcdf/bin:$DIR/grib2/bin:$PATH
# export LD_LIBRARY_PATH=$DIR/libs/lib:$DIR/libs/netcdf/lib:$DIR/libs/grib2/lib
# export JASPERLIB=$DIR/libs/grib2/lib
# export JASPERINC=$DIR/libs/grib2/include
# export NETCDF=$DIR/netcdf
# export LDFLAGS="-L$DIR/lib -L$DIR/netcdf/lib -L$DIR/grib2/lib"
# export CPPFLAGS="-I$DIR/include -I$DIR/netcdf/include -I$DIR/grib2/include"


# # zlib
# cd $HOME/Downloads
# wget https://www2.mmm.ucar.edu/people/duda/files/mpas/sources/zlib-1.2.11.tar.gz
# tar xzvf zlib-1.2.11.tar.gz
# cd zlib-1.2.11
# ./configure --prefix=$DIR/grib2
# make
# make install
# cd ..
# rm -rf zlib*


# # hdf5 library for netcdf4 functionality
# cd $HOME/Downloads
# wget https://www2.mmm.ucar.edu/people/duda/files/mpas/sources/hdf5-1.10.5.tar.bz2
# tar -xf hdf5-1.10.5.tar.bz2
# cd hdf5-1.10.5
# ./configure --prefix=$DIR --with-zlib=$DIR/grib2 --enable-fortran --enable-shared
# make
# make install
# cd ..
# rm -rf hdf5*


# ## Install NETCDF C Library
# cd $HOME/Downloads
# wget https://github.com/Unidata/netcdf-c/archive/v4.7.2.tar.gz
# tar -xf v4.7.2.tar.gz
# cd netcdf-c-4.7.2
# ./configure --enable-shared --enable-netcdf4 --disable-filter-testing --disable-dap --prefix=$DIR/netcdf
# make
# make install
# cd ..
# rm -rf v4.7.2.tar.gz netcdf-c*


# ## NetCDF fortran library
# cd $HOME/Downloads
# wget https://github.com/Unidata/netcdf-fortran/archive/v4.5.2.tar.gz
# tar -xf v4.5.2.tar.gz
# cd netcdf-fortran-4.5.2
# ./configure --enable-shared --prefix=$DIR/netcdf
# make
# make install
# cd ..
# rm -rf netcdf-fortran* v4.5.2.tar.gz


# ## MPICH
# cd $HOME/Downloads
# wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/mpich-3.0.4.tar.gz
# tar -xf mpich-3.0.4.tar.gz
# cd mpich-3.0.4
# ./configure --prefix=$DIR
# make
# make install
# cd ..
# rm -rf mpich*


# # libpng
# cd $HOME/WRF/Downloads
# wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
# tar xzvf libpng-1.2.50.tar.gz
# cd libpng-1.2.50
# ./configure --prefix=$DIR/grib2
# make
# make install
# cd ..
# rm -rf libpng*


# # JasPer
# cd $HOME/WRF/Downloads
# wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
# tar xzvf jasper-1.900.1.tar.gz
# cd jasper-1.900.1
# ./configure --prefix=$DIR/grib2
# make -j 4
# make install
# cd ..
# rm -rf jasper*



############################ WRF ######################################
## WRF
## Downloaded from git tagged releases
########################################################################
mkdir $HOME/WRF
cd $HOME/Downloads
wget -c https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz
tar -xvzf v4.5.2.tar.gz -C $HOME/WRF
cd $HOME/WRF/WRFV4.5.2
./clean
( echo 78 ; echo 1 ) | ./configure # 78, 1 for intel one api
./compile em_real

export WRF_DIR=$HOME/WRF/WRFV4.5.2

## WPS
cd $HOME/Downloads
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz
tar -xvzf v4.5.tar.gz -C $HOME/WRF
cd $HOME/WRF/WPS-4.5
./clean
( echo 19 ) | ./configure #3
./compile

# ######################## Post-Processing Tools ####################
# ## ARWpost
# cd $HOME/Downloads
# wget -c http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
# tar -xvzf ARWpost_V3.tar.gz -C $HOME/WRF
# cd $HOME/WRF/ARWpost
# ./clean
# sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRF/ARWpost/src/Makefile
# ./configure #3
# sed -i -e 's/-C -P/-P/g' $HOME/WRF/ARWpost/configure.arwp
# ./compile

# ######################## Model Setup Tools ########################
# ## DomainWizard
# cd $HOME/Downloads
# wget -c http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
# mkdir $HOME/WRF/WRFDomainWizard
# unzip WRFDomainWizard.zip -d $HOME/WRF/WRFDomainWizard
# chmod +x $HOME/WRF/WRFDomainWizard/run_DomainWizard

# ######################## Static Geography Data ####################
# # http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
# cd $HOME/WRF/Downloads
# wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
# tar -xvzf geog_high_res_mandatory.tar.gz -C $HOME/WRF


## echo exports to bashrc

echo "source /opt/intel/oneapi/setvars.sh" >> ~/.bashrc
echo "export CC=icc" >> ~/.bashrc
echo "export CXX=icpc" >> ~/.bashrc
echo "export FC=ifort" >> ~/.bashrc
echo "export F77=ifort" >> ~/.bashrc

echo "export DIR=$HOME/Library" >> ~/.bashrc
echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
echo "export HDF5=$DIR" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export CPPFLAGS=-I$DIR/include" >> ~/.bashrc
echo "export LDFLAGS=-L$DIR/lib" >> ~/.bashrc
echo "export NETCDF=$DIR" >> ~/.bashrc
echo "export JASPERLIB=$DIR/lib" >> ~/.bashrc
echo "export JASPERINC=$DIR/include" >> ~/.bashrc