FROM debian:11-slim

RUN apt update \
 && apt upgrade -y \
 && apt install -y curl git\
 && curl -fOL https://github.com/coder/code-server/releases/download/v3.12.0/code-server_3.12.0_amd64.deb \
 && dpkg -i code-server_3.12.0_amd64.deb \
 && rm code-server_3.12.0_amd64.deb

RUN apt install -y zsh \
 && chsh -s /usr/bin/zsh \
 && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
 && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
 && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
 && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

RUN apt autoremove --purge -y curl git\
 && rm ~/.bash*

EXPOSE 8443/tcp

VOLUME /root/workspace

ADD config.yaml /root/.config/code-server/config.yaml

ENTRYPOINT code-server