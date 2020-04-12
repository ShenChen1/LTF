FROM debian:buster-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    bash \
    expect \
    g++ \
    gcc \
    make \
    perl \
    pkg-config \
    python \
    vim \
    sudo \
    ssh \
 && ln -sf /bin/bash /bin/sh \
 && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
 && sed 's/''root:\*''/''root:$6$6a9oWBiKXkD67zg1$wf3QHkMt5gVzejB1ZWsooWg45jWoeBFRm5BCRRRu1G15xkJOhYQlrafhGGsrECtSOJbWIYRd14aZl44blJoFz.''/g' -i /etc/shadow

CMD /etc/init.d/ssh restart && /bin/bash
