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

echo "Activate Python"
cd /home/vagrant/
pyenv global 3.9.10

echo "Install Depdendencies"
pip install --upgrade pip
pip install wheel

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

echo "Setup login directory"
echo "source ~/.bashrc"  >> /home/vagrant/.bash_profile
