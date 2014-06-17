FROM phusion/baseimage:0.9.10

MAINTAINER github.com/jasonswindle

# Set correct environment variables.
ENV HOME /root

# Set root's password
RUN echo "root:changeme" | chpasswd

# Add the user rsync, touch the authorized_keys file, chown
RUN useradd rsync_user --create-home
ADD ./files/rsync_user/authorized_keys /home/rsync_user/.ssh/
RUN chown rsync_user:rsync_user -R /home/rsync_user/.ssh \
            && chmod 0700 /home/rsync_user/.ssh \
            && chmod 0644 /home/rsync_user/.ssh/authorized_keys

# Update apt's cache
RUN apt-get update

## Install what we need
RUN apt-get install -y -q --no-install-recommends \
            python-pip \
            man \
            wget \
            sudo \
            software-properties-common \
            locales \
            ca-certificates \
            ntp

# Ensure UTF-8
RUN locale-gen en_US.UTF-8 && update-locale

# Set the timezone
RUN echo "US/Central" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Install Salt Master (of Masters)
RUN add-apt-repository ppa:saltstack/salt

# Update the apt database
RUN apt-get update

# Install Salt Master
RUN apt-get install -y -q --no-install-recommends \
            salt-master

# Make this Salt Master, Master of Masters
RUN echo "order_masters: True" > /etc/salt/master.d/syndic.conf

# Add runit scripts
ADD ./files/runit/ /etc/service/

# Correct the perms, so RUNIT can run...
RUN chmod 0755 -Rv /etc/service/

# SSH Config
ADD ./files/ssh/sshd_config /etc/ssh/

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
