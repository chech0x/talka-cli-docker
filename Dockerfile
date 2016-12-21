#Build con:
#docker build -t klabs/talka-cli:0.1.0 -f Dockerfile .
#Push:
#docker tag klabs/talka-cli:0.1.0 docker-r01.kvz.local:5000/klabs/talka-cli:0.1.0
#docker push docker-r01.kvz.local:5000/klabs/talka-cli:0.1.0
#
#Para usar en windows se debe tener un directorio con las claves públicas y privadas:
# docker run -ti --rm -v /c/Users/$USERNAME/developer/ssh:/root/.ssh -v /c/Users/$USERNAME/developer/workdir:/root/workdir -e SSH_KEY_FILE=ARCHIVO_CLAVE_PRIVADA docker-r01.kvz.local:5000/klabs/talka-cli:0.1.0
#donde: ARCHIVO_CLAVE_PRIVADA debe cambiarse por el nombre del archivo de clave privada rsa
#Dentro del contenedor podemos loguearnos a talka-cli
# deis login deis.talka.kvz.local

FROM centos:7
MAINTAINER Sergio Campos <scampos@klabs.cl>

RUN yum -y update && \
 yum -y install git bzip2 unzip net-tools && \
 curl -sSL http://deis.io/deis-cli/install.sh | sh && \
 mv deis  /usr/local/bin/deis && \
 yum -y clean all

RUN  echo "#!/bin/bash" > /root/prepareSSH.sh && \
  echo "" >> /root/prepareSSH.sh && \
  echo "mkdir -p /root/.ssh" >> /root/prepareSSH.sh && \
#  echo "cp /root/ssh/* /root/.ssh" >> hello.sh && \
  echo "chmod -R 500 /root/.ssh" >> /root/prepareSSH.sh && \
  echo "eval \`ssh-agent -s\`" >> /root/prepareSSH.sh && \
  echo "ssh-add /root/.ssh/\$SSH_KEY_FILE" >> /root/prepareSSH.sh && \
  echo "" >> /root/.bash_profile && \
  echo ". /root/prepareSSH.sh" >> /root/.bash_profile

WORKDIR /root/workdir

ENTRYPOINT ["/bin/bash"]
CMD ["-l"]
