docker_public
=============

A development environment built around docker and services running in
containers. This was forked from "A Docker Dev Environment in 24 Hours!" and
hacked for my own ends:

 * http://blog.relateiq.com/a-docker-dev-environment-in-24-hours-part-2-of-2/


Installation
============

MacOS
-----

I've used this with Vagrant version 1.4.3 and Virtualbox 4.3.6 (r91406).

Check out the repository
------------------------

Recover the project and start the VM::

    git clone https://github.com/oisinmulvihill/docker_public.git
    cd docker_public
    vagrant up

When prompted reload the vagrant::

    vagrant reload

Then run the devenv update to finalise the install process and perform the
shipyard set up.

    ./bin/devenv update

I need to document the shipyard bit more as its not yet working.


DevEnv Usage
============

This calls are do from the checked out docker_public folder.

Build the container images
--------------------------

This will create all the images that are needed when calling start or stop::

    ./bin/devenv build_images


Run devenv
----------

Start the devenv which will run all the containers::

    ./bin/devenv start

You should see::

    $ ./bin/devenv start
    Started REDIS in container f49c9910da35
    Started ELASTICSEARCH in container 802a9f1139d9
    Started MONGO in container 33e5df9178a4
    Started RIAK in container 52f3233972fb
    Started DEVOX in container d3475cfe8161


stop || kill
------------

Stop or kill all running containers::

    ./bin/devenv start
    # OR
    ./bin/devenv kill


See what is running
-------------------

You can call status to see the containers on the VM::

    ./bin/devenv status
