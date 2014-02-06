docker_public
=============

A development environment built around docker and services running in
containers. This was forked from "A Docker Dev Environment in 24 Hours!" and
hacked for my own ends:

* http://blog.relateiq.com/a-docker-dev-environment-in-24-hours-part-2-of-2/

This may not be in a running state as I've noticed the image building needs
updating every few weeks as various project versions tick over.


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
    Started MONGO in container 33e5df9178a4
    Started RIAK in container 52f3233972fb
    :
    etc

You can connect in and look around with ssh::

    ./bin/devenv ssh

You could also tunnel access from localhost on the host machine to the various
running services running inside the VM::

    # Redis on: 6379, Mongo on: 27017, Riak on: 8098
    vagrant ssh -- -L6379:localhost:6379 -L27017:localhost:27017 -L28017:localhost:28017 -L8098:localhost:8098 -N


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
