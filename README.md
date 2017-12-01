gurimusan blog
==============

https://gurimusan.github.io/blog/

Setup
-----

Install hugo.

    $ go get -v github.com/spf13/hugo

Clone blog.

    $ git clone git@github.com:gurimusan/gurimusan.github.io.git
    $ cd gurimusan.github.io

Install Theme

    $ mkdir themes
    $ cd themes
    $ git clone git@github.com:gurimusan/hugo-theme-slim.git slim

Hugo
----

Create new.

    $ hugo new post/<filenmae>.md

Run loal server.

    $ hugo server -D --bind 0.0.0.0

Create publish contents.

    $ hugo

Run in docker
-------------

build docker image,

    $ docker build -t gurimusan/blog .

run docker

    $ docker run -it \
        -u $UID:$GID \
        -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK \
        -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
        -v /etc/localtime:/etc/localtime:ro \
        -v pwd:/home/gurimusan/project \
        -p 1313:1313 \
        -w /home/gurimusan/blog
        gurimusan/blog
