# cual es la imagen base que vamos a utilizar
FROM ubuntu:14.04

#quien es el usuario o corporacion que se encarga mantener la imagen
MAINTAINER Sven Dowideit <SvenDowideit@docker.com>

# actualización del sistema y posterior instalación de loservicios ssh
RUN apt-get update && apt-get install -y openssh-server

#crear el directorio para sshd
RUN mkdir /var/run/sshd

#cambiar la password del usuario root
RUN echo 'root:screencast' | chpasswd

#modificar el fichero de sshd_config para permitir el accesso con Root
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# establecer un valor para la variable notvisible
ENV NOTVISIBLE "in users profile"

#agrega esa información al profile
RUN echo "export VISIBLE=now" >> /etc/profile

#exponer el puerto 22
EXPOSE 22

# comando a ejecutar una vez se crear el contenedor. Ejecuta SSH
CMD ["/usr/sbin/sshd", "-D"]
