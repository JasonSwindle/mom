## Used Ubuntu 12:04 vs 14:04 because of odd issues with --net and chpasswd

FROM ubuntu:12.04

MAINTAINER github.com/JasonSwindle

## Envs needed to make everthing work
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

## Ports for Salt and SSH
EXPOSE 4505 4506 16022

## Set root's password
RUN echo "root:changeme" | chpasswd

## Update the apt database
RUN apt-get update

## Install what we need
RUN apt-get install -y \
            python-pip \
            ca-certificates \
            sudo \
            openssh-server \
            software-properties-common \
            python-software-properties \
            vim \
            locales \
            ntp

## Install Supervisor
RUN mkdir /var/log/supervisor; pip install supervisor

## Set the timezone
RUN echo "US/Central" > /etc/timezone; dpkg-reconfigure tzdata

## Install Salt Master (of Masters)
RUN add-apt-repository ppa:saltstack/salt

## Update the apt database
RUN apt-get update

## Install Salt Master
RUN apt-get install -y salt-master

## Make this Salt Master, Master of Masters
RUN echo "order_masters: True" > /etc/salt/master.d/syndic.conf

## Bounce the Salt Master
RUN service salt-master restart

## Make the SSH dir
RUN mkdir /var/run/sshd

## Move SSH to a different port
RUN sed -i 's/Port 22/Port 16022/' /etc/ssh/sshd_config

## Make Salt-Master and SSHD a service
ADD ./files/supervisor/supervisord.conf /etc/
ADD ./files/supervisor/salt.conf /etc/supervisor/conf.d/
ADD ./files/supervisor/ssh.conf /etc/supervisor/conf.d/
ADD ./files/supervisor/ntpd.conf /etc/supervisor/conf.d/

## Remove the apt database
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
