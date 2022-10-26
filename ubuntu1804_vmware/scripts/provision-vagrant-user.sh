#!/bin/bash

echo "Install pyenv (assuming bashrc)"
touch ~/.bash_profile
grep -q -F "export PYENV_ROOT=\"/home/vagrant/.pyenv\"" ~/.bash_profile || echo "export PYENV_ROOT=\"/home/vagrant/.pyenv\"" >> ~/.bash_profile
grep -q -F "export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" ~/.bash_profile || echo "export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >> ~/.bash_profile
source ~/.bash_profile
grep -q -F "eval \"\$(pyenv init --path)\"" ~/.bash_profile || echo "eval \"\$(pyenv init --path)\"" >> ~/.bash_profile
grep -q -F "eval \"\$(pyenv init -)\"" ~/.bash_profile || echo "eval \"\$(pyenv init -)\"" >> ~/.bash_profile
grep -q -F "eval \"\$(pyenv virtualenv-init -)\"" ~/.bash_profile || echo "eval \"\$(pyenv virtualenv-init -)\"" >> ~/.bash_profile
curl -s -S -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
source ~/.bash_profile

echo "Install Python 3.9.10"
pyenv install 3.9.10
pyenv install 2.7.18

echo "Activate Python"
cd /home/vagrant/
pyenv global 3.9.10

echo "Install Depdendencies"
pip install --upgrade pip
pip install wheel
pip install z3-solver pwntools pycryptodome capstone ropgadget stegoveritas xortool keystone-engine ropper 
stegoveritas_install_deps

echo "Tools"
cd /home/vagrant/
mkdir tools
cd tools
git clone https://github.com/beanbeah/volatility--custom.git
cd volatility--custom
pyenv local 2.7.18
pip install pycryptodome distorm3 construct
cd ..
git clone https://github.com/volatilityfoundation/volatility3.git
git clone https://github.com/kimci86/bkcrack.git
cd bkcrack
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=install
cmake --build build --config Release
cmake --build build --config Release --target install
cd /home/vagrant/tools
git clone https://github.com/keyunluo/pkcrack
mkdir pkcrack/build
cd pkcrack/build
cmake ..
make

echo "Installing Patchelf"
cd /home/vagrant/tools
git clone https://github.com/NixOS/patchelf.git
cd patchelf
./bootstrap.sh
./configure
make
make check
sudo make install

echo "Installing libc-database"
cd /home/vagrant/tools/
git clone https://github.com/niklasb/libc-database.git

echo "Setup GDB"
cd /home/vagrant/tools/
git clone https://github.com/pwndbg/pwndbg
cd pwndbg
./setup.sh
cd ..
mv pwndbg pwndbg-src
git clone https://github.com/longld/peda.git /home/vagrant/tools/peda
wget -q -O gdbinit-gef.py https://github.com/hugsy/gef/raw/master/gef.py
cd /home/vagrant/
cat >.gdbinit <<EOL
define init-peda
source /home/vagrant/tools/peda/peda.py
end
document init-peda
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework
end

define init-pwndbg
source /home/vagrant/tools/pwndbg-src/gdbinit.py
end
document init-pwndbg
Initializes PwnDBG
end

define init-gef
source /home/vagrant/tools/gdbinit-gef.py
end
document init-gef
Initializes GEF (GDB Enhanced Features)
end
EOL


echo "Install SageMath"
cd /home/vagrant/tools
wget https://mirrors.aliyun.com/sagemath/linux/64bit/sage-9.4-Ubuntu_18.04-x86_64.tar.bz2
tar -xvf sage-9.4-Ubuntu_18.04-x86_64.tar.bz2
cd SageMath
timeout 2m ./sage
sudo ln -s /home/vagrant/tools/SageMath/sage /usr/local/bin/sage
sudo rm -rf sage-9.4-Ubuntu_18.04-x86_64.tar.bz2
source ~/.bashrc

echo "Configure Sage"
sage -pip install pwntools z3-solver pycryptodome

echo "Setup login directory"
echo "source ~/.bashrc"  >> /home/vagrant/.bash_profile
