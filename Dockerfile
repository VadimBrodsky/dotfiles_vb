FROM ubuntu:18.04

# Better terminal support
ENV TERM screen-256color
ENV DEBIAN_FRONTEND noninteractive

# Update and install
RUN apt-get update && apt-get install -y \
      htop \
      fish \
      curl \
      wget \
      git \
      software-properties-common \
      python-dev \
      python-pip \
      python3-dev \
      python3-pip \
      locales

# Locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Other Repos
RUN add-apt-repository ppa:neovim-ppa/stable
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN apt-get update && apt-get install -y \
      neovim \
      nodejs \
      yarn

WORKDIR /root

# RipGrep
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb \
    && dpkg -i ripgrep_0.10.0_amd64.deb \
    && rm ripgrep_0.10.0_amd64.deb

# Dotfiles
ADD . /root/dotfiles
RUN ~/dotfiles/install

# Fisher
RUN curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# Vim Plug
RUN mkdir -p ~/.config/nvim/autoload \
    && wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.config/nvim/autoload/plug.vim \
    && nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1 \
    && nvim -i NONE -c UpdateRemotePlugins -c quitall > /dev/null 2>&1

RUN npm install -g neovim

CMD ["/usr/bin/fish"]
# https://github.com/thornycrackers/docker-neovim/blob/master/Dockerfile
