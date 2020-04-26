FROM debian:buster-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    bash \
    expect \
    g++ \
    gcc \
    make \
    iproute2 \
    python \
    vim \
    sudo \
    ssh \
 && ln -sf /bin/bash /bin/sh \
 && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
 && echo root:123456 | chpasswd

CMD /etc/init.d/ssh restart && /bin/bash
