#!/usr/bin/env bash -x

set -e

function install_atp_get(){
package=$1
echo "Install ${package} ..."
sudo apt-get -y install ${package}
}

function get_filename_without_extension(){
fullfilename=$1
filename=$(basename "$fullfilename")
fname="${filename%.*}"
echo ${fname}
}

function install_glpk(){
wget https://ftp.gnu.org/gnu/glpk/glpk-4.63.tar.gz
tar -zxvf glpk-4.63.tar.gz
cd glpk-4.63
./configure --disable-shared
make && make install
}

function install_lemon_cxx(){
echo "Download Lemon C++"
wget http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz
echo "Decompress lemon-1.3.1.tar.gz"
tar -zxvf lemon-1.3.1.tar.gz
cd lemon-1.3.1
echo "Compiling"
mkdir build && cd build
cmake ..
make && make install
}

function install_boost_cxx(){
echo "Download boost C++"
wget https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz
echo "Decompress boost_1_65_1.tar.gz"
tar -zxvf boost_1_65_1.tar.gz
cd boost_1_65_1
echo "Configure ..."
./bootstrap.sh
echo "Install ..."
./b2 install
}

function install_with_git_and_cmake(){
git_rep=$1
rep_name=$(get_filename_without_extension "$git_rep")
git clone "$git_rep"
cd ${rep_name}
make build && cd build
cmake ..
make && make install
}


function install(){
mkdir ~/temp && cd ~/temp
for package in $(cat apt_get.txt)
do
install_atp_get ${package}
done

install_glpk
cd ~/temp

install_boost_cxx
cd ~/temp

install_lemon_cxx
cd ~/temp

for repo in $(cat git_repos.txt)
do
cd ~/temp
install_with_git_and_cmake ${repo}
done

cd ~
rm -rf temp
}


install
