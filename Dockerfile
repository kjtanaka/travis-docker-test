FROM centos:centos6
MAINTAINER Koji Tanaka <kj.tanaka@gmail.com>

RUN yum -y install openssh-server && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN echo 'root:$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)' | chpasswd

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

RUN echo "echo \$AUTHORIZED_KEYS > /root/.ssh/authorized_keys" > /run.sh
RUN echo "chmod 600 /root/.ssh/authorized_keys" >> /run.sh
RUN echo "/usr/sbin/sshd -D" >> /run.sh

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/bin/bash", "/run.sh"]
