#!/bin/bash

echo "Install pyenv"
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
pip install jupyterlab widgetsnbextension jupyter-jsmol nbconvert jupyterlab_latex jupyterlab_tabnine
pip install z3-solver pwntools pycryptodome
pip install Pebble scikit-learn tensorflow matplotlib numpy pandas

echo "Setup Jupyter"
echo 'export PWNLIB_NOTERM=1' >> ~/.bashrc #used to enable pwntools support
source ~/.bashrc
#themes
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install @arbennett/base16-mexico-light
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install @arbennett/base16-monokai
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install @arbennett/base16-gruvbox-dark
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install @arbennett/base16-one-dark

echo "Setup login directory"
echo "source ~/.bashrc"  >> /home/vagrant/.bash_profile