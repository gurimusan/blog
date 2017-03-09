gurimusan blog
==============

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
    $ git clone https://github.com/zhe/hugo-theme-slim slim


Hugo
----

Create new.

    $ hugo new post/<filenmae>.md

Run loal server.

    $ hugo server -D

Create publish contents.

    $ hugo
