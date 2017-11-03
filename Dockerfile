FROM gurimusan/nvim
MAINTAINER gurimusan@gmail.com

USER root

ENV HUGO_VERSION=0.30.2
RUN apk add --update wget ca-certificates && \
  cd /tmp/ && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  mv hugo /usr/bin/hugo && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

USER gurimusan
WORKDIR /home/gurimusan

COPY dein.toml /tmp/dein.toml
RUN cat /tmp/dein.toml >> /home/gurimusan/.config/dein/dein.toml
RUN nvim +":silent! call dein#install()" +qall
RUN nvim +"UpdateRemotePlugins" +qall

CMD ["/bin/zsh"]
