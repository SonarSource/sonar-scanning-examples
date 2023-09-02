FROM ubuntu:bionic-20180426

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get upgrade -y

# Sensitive
RUN apt install -y build-essential

RUN curl http://www.example.com/

# Noncompliant
RUN curl --tlsv1.0 -O https://tlsv1-0.example.com/downloads/install.sh

#Curl Vulnerability https://www.cvedetails.com/cve/CVE-2018-1000300/
RUN apt-get install -y curl && \
#GIT Vulnerability CVE https://www.cvedetails.com/cve/CVE-2018-17456/
    apt-get install -y git && \
#OpenSSH Vulnerability https://www.cvedetails.com/cve/CVE-2018-15473/
    apt-get install -y openssh-server && \
#Installation of ftp server
    apt-get install -y proftpd

COPY ./userfiles/shadow /etc/shadow
COPY ./userfiles/passwd /etc/passwd
RUN chmod o-rwx /etc/shadow
RUN chmod o-rwx /etc/passwd
COPY ./user-data-ftp/ /home/
COPY ./sshd_config /etc/ssh/sshd_config
RUN service ssh start
CMD ["proftpd", "--nodaemon"]

# TODO Not correctly configure for ARM architecture
#LibreOffice Vulnerability CVE https://www.cvedetails.com/cve/CVE-2019-9851/
#RUN curl -LO https://downloadarchive.documentfoundation.org/libreoffice/old/6.2.3.1/deb/x86_64/LibreOffice_6.2.3.1_Linux_x86-64_deb.tar.gz
#RUN tar zxf LibreOffice_6.2.3.1_Linux_x86-64_deb.tar.gz
#RUN cd LibreOffice_6.2.3.1_Linux_x86-64_deb/DEBS/ && \
#    dpkg -i *.deb
#RUN rm LibreOffice_6.2.3.1_Linux_x86-64_deb.tar.gz
