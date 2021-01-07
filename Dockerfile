FROM centos:centos8

# Install all libraries needed for SAP ASE on CentOS Linux
RUN yum -y update && \
yum -y install kernel glibc gzip unzip passwd openmotif libXp libXt libXtst libXi libXmu libXext libSM libICE libX11 libXtst-devel libXi-devel openmotif-devel libXmu-devel libXt-devel libXext-devel libXp-devel libX11-devel libSM-devel libICE-devel libaio libnsl && \
yum -y clean all

WORKDIR /opt/sap

# Install SAP JVM 8
COPY sapjvm-8.1.067-linux-x64.zip ./

RUN unzip sapjvm-8.1.067-linux-x64.zip && \
rm -rf sapjvm-8.1.067-linux-x64.zip

COPY ASE_Suite.linuxamd64.tgz /tmp/ASE_Suite.linuxamd64.tgz

# Response file that allows for a silent installation of SAP ASE Express Edition
ADD install_response.txt /tmp/install_response.txt

# Install SAP ASE Express Edition
RUN cd /tmp && \
tar -xzvf ASE_Suite.linuxamd64.tgz && \
rm -rf ASE_Suite.linuxamd64.tgz && \
chmod +x setup.bin && \
export LAX_DEBUG=true && \
./setup.bin LAX_VM /opt/sap/sapjvm_8/bin/java -f /tmp/install_response.txt -i silent && \
ln -s /opt/sap/SYBASE.sh /etc/profile.d/sybase.sh

# Script to start SAP ASE when the container starts
ADD start_SYBASE.sh /opt/sap/start_SYBASE.sh

# Enables connection to the container at 127.0.0.1:5000
ADD interfaces /opt/sap/interfaces

RUN chmod +x /opt/sap/start_SYBASE.sh && \
chmod 644 /opt/sap/interfaces

EXPOSE 5000

CMD /opt/sap/start_SYBASE.sh
