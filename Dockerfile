FROM phusion/baseimage:0.9.10

MAINTAINER github.com/jasonswindle

# https://github.com/dotcloud/docker/issues/4846 and move SSH to a different port
RUN sed -i 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/' /etc/pam.d/sshd

# Set root's password
RUN echo "root:changeme" | chpasswd

# Set correct environment variables.
ENV HOME /root

# Update apt's cache
RUN apt-get update

## Install what we need
RUN apt-get install -y \
            python-pip \
            sudo \
            software-properties-common \
            locales \
            ntp

# Ensure UTF-8
RUN locale-gen en_US.UTF-8 && update-locale

# Install Salt Master (of Masters)
RUN add-apt-repository ppa:saltstack/salt

# Update the apt database
RUN apt-get update

# Install Salt Master
RUN apt-get install -y salt-master

# Make this Salt Master, Master of Masters
RUN echo "order_masters: True" > /etc/salt/master.d/syndic.conf

# Set the timezone
RUN echo "US/Central" > /etc/timezone; dpkg-reconfigure tzdata

# Add runit scripts
ADD ./files/runit/ /etc/service/

# Correct the perms, so RUNIT can run...
RUN chmod 0755 -Rv /etc/service/

# SSH Config
ADD ./files/ssh/sshd_config /etc/ssh/sshd_config

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
