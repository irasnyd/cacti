FROM centos:7

EXPOSE 80
ENTRYPOINT [ "/init" ]

RUN yum -y install epel-release \
        && yum -y install cacti cronie mod_php php-ldap supervisor \
        && yum -y clean all

COPY processes.ini /etc/supervisord.d/
COPY init /
