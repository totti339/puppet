FROM ubuntu:16.04

LABEL maintainer "coveo"

# Config for Puppet
ENV PUPPETMASTER_SERVER_VERSION 3.8.5

# Config for Foreman
ENV FOREMAN_RELEASE 1.15
ENV FOREMAN_PROXY_VERSION 1.15.0-1

# Install Supervisor
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor

# Install Puppet 
RUN apt-get install wget && \
    wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb -O- | dpkg -i - && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y puppetmaster=$PUPPETMASTER_SERVER_VERSION-2ubuntu0.1 && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Foreman-proxy
RUN wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
    echo "deb http://deb.theforeman.org/ xenial $FOREMAN_RELEASE" > /etc/apt/sources.list.d/foreman.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      foreman-proxy=$FOREMAN_PROXY_VERSION

EXPOSE 8443
EXPOSE 8140

COPY files/supervisord /etc/supervisor

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
