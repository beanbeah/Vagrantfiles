#!/bin/bash

echo "Install system requirements"
sudo sed -i 's|http://archive.ubuntu.com|http://mirror.0x.sg|g' /etc/apt/sources.list
apt-get --quiet update
apt-get install -y curl git libssl-dev libffi-dev libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev ruby-full

echo "Install pyenv requirements"
apt-get install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl

echo "Install pyenv"
curl -# -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

echo "Install gems"
gem install zsteg
gem install one_gadget

echo "Install Docker"
apt-get remove -y docker docker-engine docker.io containerd runc
apt-get --quiet update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get --quiet update
apt-get install -y docker-ce docker-ce-cli containerd.io
groupadd docker
usermod -aG docker vagrant
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "Install others"
apt-get install -y aircrack-ng foremost pngcheck libimage-exiftool-perl outguess steghide stegsnow
apt-get install -y texlive-latex-extra texlive-xetex latexmk dvipng default-jdk ffmpeg libavdevice-dev coinor-cbc coinor-libcbc-dev pari-gp2c libigraph-dev libisl-dev libnauty-dev libxml2-dev lrslib ninja-build libxml-libxslt-perl libxml-writer-perl libxml2-dev libperl-dev libfile-slurp-perl libjson-perl libsvg-perl libterm-readkey-perl libterm-readline-gnu-perl libmongodb-perl libterm-readline-gnu-perl texlive-full ffmpeg imagemagick

echo "Setup gdbenv"
wget https://gist.githubusercontent.com/beanbeah/b7f96e67a930dbfdb48ababd2e01b8d7/raw/e585f4333245f6f132a58805d9c0d4d3a629df5b/gdbenv /usr/local/bin/gdbenv
sudo chmod +x /usr/local/bin/gdbenv
