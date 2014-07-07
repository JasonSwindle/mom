FROM phusion/baseimage:0.9.11

MAINTAINER github.com/jasonswindle

# Set correct environment variables.
ENV HOME /root

# Set root's password
RUN echo "root:changeme" | chpasswd

# Stop daemon from starting on install
RUN echo 'exit 101' >> /usr/sbin/policy-rc.d

# Add the user rsync, touch the authorized_keys file, chown
RUN useradd rsync_user --create-home
ADD ./files/rsync_user/authorized_keys /home/rsync_user/.ssh/
RUN chown rsync_user:rsync_user -R /home/rsync_user/.ssh \
            && chmod 0700 /home/rsync_user/.ssh \
            && chmod 0644 /home/rsync_user/.ssh/authorized_keys

# Update apt's cache
RUN apt-get update -qq

## Install what we need
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes -qq --no-install-recommends \
            python-pip \
            man \
            wget \
            sudo \
            locales \
            ntp

# Ensure UTF-8
RUN locale-gen en_US.UTF-8 && update-locale

# Set the timezone
RUN echo "US/Central" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Install Salt Master (of Masters)
RUN add-apt-repository ppa:saltstack/salt

# Update the apt database
RUN apt-get update -qq

# Install Salt Master
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes -qq --no-install-recommends \
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
