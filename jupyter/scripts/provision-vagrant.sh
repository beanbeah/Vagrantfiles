#!/bin/bash

echo "Install system requirements"
sudo sed -i 's|http://us.archive.ubuntu.com|http://mirror.0x.sg|g' /etc/apt/sources.list
apt-get --quiet update
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
apt-get install -y curl git libssl-dev libffi-dev nodejs build-essential

echo "Install pyenv requirements"
apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

echo "Install pyenv"
curl -# -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

echo "Install Jupyter Optional Packages"
apt-get install -y texlive texlive-xetex texlive-fonts-recommended texlive-plain-generic latexmk pandoc dvipng default-jdk ffmpeg libavdevice-dev

echo "Setup Jupyter auto start"
cat >/etc/systemd/system/jupyter.service <<EOL
[Unit]
Description=Jupyter
[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=/home/vagrant/.pyenv/versions/3.9.10/bin/jupyter lab --port=8888 --no-browser --ip=0.0.0.0 --NotebookApp.token= --notebook-dir=/ctf-shared
User=vagrant
Group=vagrant
WorkingDirectory=/ctf-shared
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
EOL

systemctl enable jupyter.service
systemctl daemon-reload
systemctl restart jupyter.service
