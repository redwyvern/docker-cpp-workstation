FROM docker.artifactory.weedon.org.au/redwyvern/cpp-devenv-base
MAINTAINER Nick Weedon <nick@weedon.org.au>

ARG GIT_USER="Nick Weedon"
ARG GIT_EMAIL=nick@weedon.org.au

# Note that 'xauth' is needed for X11 Forwarding
RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends \
    strace \
    vim \
    git \
    file \
    xauth \
    x11-apps \
    libxtst6 \
    libxi6 \
    less \
    sudo && \
    apt-get -q autoremove && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

USER root

COPY ./usr /usr

######################## Install the CLion IDE ###############################

RUN cd /opt && \
    wget -nv https://download.jetbrains.com/cpp/CLion-2016.2.1.tar.gz && \
    tar -xzf CLion-2016.2.1.tar.gz && \
    rm CLion-2016.2.1.tar.gz
    
######################################################################

VOLUME /home

RUN useradd -m developer -G sudo -s /bin/bash \
    && sed -i 's/%sudo[[:space:]]*ALL=(ALL:ALL)[[:space:]]*ALL/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers \
    && chown developer.developer -R /home/developer    

USER developer

COPY authorized_keys /home/developer/.ssh/authorized_keys

RUN git config --global user.name "${GIT_USER}" && \
    git config --global user.email "${GIT_EMAIL}" && \
    git config --global push.default simple

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]

