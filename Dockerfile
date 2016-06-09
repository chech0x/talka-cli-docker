FROM centos:7
MAINTAINER "chech0x" <scampos@klabs.cl>
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]


RUN /usr/bin/yum -y install net-tools
RUN /usr/bin/yum -y install git
RUN /usr/bin/yum -y install go
RUN /usr/bin/yum -y install make
RUN /usr/bin/yum -y install file
RUN /usr/bin/yum -y install bzip2

RUN /usr/bin/mkdir ~/go
RUN export GOPATH=~/go && export PATH="$PATH:$GOPATH/bin" && go get github.com/tools/godep

RUN /usr/bin/mkdir -p /tmp/talkaInstaller
RUN cd /tmp/talkaInstaller && curl -f -L -O  https://github.com/chech0x/talka/releases/download/0.0.2-dev/talka-cli-0.0.2-dev-linux-amd64.run && sh talka-cli-0.0.1-dev-linux-amd64.run &&  /usr/bin/mv talka /usr/bin/ &&  cd / && rm -f -R /tmp/talkaInstaller

CMD eval `ssh-agent -s`
CMD export GOPATH=~/go
CMD export PATH=$PATH:$GOPATH/bin

CMD ["/usr/sbin/init"]






