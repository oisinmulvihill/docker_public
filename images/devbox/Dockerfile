#
# A 'devbox' to connect into which has a running
#
FROM ubuntu:latest
MAINTAINER Oisin Mulvihill

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y curl lsb-release supervisor openssh-server
RUN apt-get install -y build-essential \
 python \
 python-dev \
 python-setuptools \
 python-virtualenv \
 virtualenvwrapper
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN locale-gen en_US en_US.UTF-8

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Hack for initctl
# See: https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# SSHd running for people to connect in on:
EXPOSE 22

CMD ["/usr/bin/supervisord"]
