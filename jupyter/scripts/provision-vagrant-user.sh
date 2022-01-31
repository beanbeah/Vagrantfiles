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

echo "Install SageMath"
wget https://mirrors.tuna.tsinghua.edu.cn/sagemath/linux/64bit/sage-9.4-Ubuntu_20.04-x86_64.tar.bz2
tar -xvf sage-9.4-Ubuntu_20.04-x86_64.tar.bz2
cd SageMath
timeout 2m ./sage
sudo ln -s /home/vagrant/SageMath/sage /usr/local/bin/sage
rm -rf sage-9.4-Ubuntu_20.04-x86_64.tar.bz2
source ~/.bashrc

echo "Install Depdendencies"
pip install --upgrade pip
pip install jupyterlab widgetsnbextension jupyter-jsmol nbconvert jupyterlab_latex
pip install z3-solver pwntools pycryptodome
pip install Pebble scikit-learn tensorflow

echo "Configure Sage"
sage -pip install pwntools z3-solver pycryptodome

echo "Setup Jupyter"
echo 'export PWNLIB_NOTERM=1' >> ~/.bashrc #used to enable pwntools support
source ~/.bashrc
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install @kaggle/jupyterlab
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter kernelspec install --user /home/vagrant/SageMath/local/share/jupyter/kernels/sagemath
#themes
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install base16-mexico-light
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install base16-monokai
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install base16-gruvbox-dark
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter labextension install base16-one-dark
#tabnine
pip install jupyter-tabnine --user
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter nbextension install --py jupyter_tabnine --user
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter nbextension enable --py jupyter_tabnine --user
/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter serverextension enable --py jupyter_tabnine --user

echo "Setup login directory"
echo "source ~/.bashrc"  >> /home/vagrant/.bash_profile