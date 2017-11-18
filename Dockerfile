FROM docker.artifactory.weedon.org.au/redwyvern/ubuntu-devenv-base
MAINTAINER Nick Weedon <nick@weedon.org.au>

ARG GIT_USER="Nick Weedon"
ARG GIT_EMAIL=nick@weedon.org.au

# Note that 'xauth' is needed for X11 Forwarding
RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends \
    strace \
    vim \
    file \
    xauth \
    x11-apps \
    libxtst6 \
    libxi6 \
    less \
    sudo && \
    apt-get -q autoremove && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN useradd -m -s /bin/bash -G sudo nickw && \
    echo "nickw:password" | chpasswd

USER nickw

COPY authorized_keys /home/nickw/.ssh/authorized_keys
COPY settings.xml /home/nickw/.m2/settings.xml

RUN git config --global user.name "${GIT_USER}" && \
    git config --global user.email "${GIT_EMAIL}" && \
    git config --global push.default simple

RUN mkdir ~/src

USER root

VOLUME /home/nickw/src

COPY ./usr /usr

RUN chown -R nickw.nickw /home/nickw

######################## Install the CLion IDE ###############################

USER root

#RUN cd /opt && \
#    wget -nv https://download.jetbrains.com/cpp/CLion-2016.2.1.tar.gz && \
#    tar -xzf CLion-2016.2.1.tar.gz && \
#    rm CLion-2016.2.1.tar.gz
    
    #ln -s /opt/clion-2016.2.1/bin/clion.sh /usr/bin/clion

#echo 'export MAKEFLAGS="-j4"' >>/home/nickw/.bashrc

######################################################################

# Standard SSH port
EXPOSE 22

# Default command
CMD ["/usr/sbin/sshd", "-D"]

