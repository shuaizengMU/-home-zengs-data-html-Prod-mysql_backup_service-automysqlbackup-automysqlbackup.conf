FROM centos:7

RUN yum upgrade -y 
RUN yum install -y mysql
RUN yum install -y mailx 
RUN yum install -y cronie 
RUN yum -y install sendmail; yum clean all; systemctl enable sendmail.service
RUN yum install -y crontabs; yum clean all; systemctl enable crond.service

WORKDIR /etc/automysqlbackup/ 

# Install tool
COPY automysqlbackup/automysqlbackup-v3.0_rc6.tar.gz ./
RUN tar xvzf ./automysqlbackup-v3.0_rc6.tar.gz
RUN ./install.sh

# Please modify the conf file before running.
COPY automysqlbackup/automysqlbackup.conf automysqlbackup.conf

# run script everyday at 00:00
RUN crontab -l | { cat; echo "0 0 * * * /usr/local/bin/automysqlbackup /etc/automysqlbackup/automysqlbackup.conf >> /etc/automysqlbackup/log/cron.log 2>&1"; } | crontab -

CMD ["/usr/sbin/init"]