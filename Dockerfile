FROM debian:sid

MAINTAINER lrinQVQ <lrin@qvqnetwork.net>

ENV USERNAME

ENV PASSWORD

RUN apt update && apt install wget gnupg2 libreadline-dev -y && apt upgrade -y

RUN echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list

RUN wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key && rm -f nginx_signing.key

RUN apt update

RUN apt install nginx openssh-server -y

RUN mkdir /var/run/sshd

RUN if [ "$USERNAME" != "root" ]; then useradd -b /home/$USERNAME -d /home/$USERNAME -m $USERNAME ; fi

RUN echo "$USERNAME:$PASSWORD" | chpasswd

RUN if [ "USERNAME" = "root" ]; then echo "PermitRootLogin yes" >> /etc/ssh/sshd_config ; fi

RUN sed -i 's|session.*required.*pam_loginuid.so|session optional pam_loginuid.so|' /etc/pam.d/sshd

ADD start /usr/bin

EXPOSE 22 80 443

VOLUME ["/etc/nginx", "/var/www/html", "/root"]

CMD ["sh", "/usr/bin/start"]
