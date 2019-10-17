FROM jupyter/scipy-notebook:cf6258237ff9

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# ---------------------------------------------------------------------------------------------------------------------
# Install Docker
USER root
RUN apt-get update && apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"
RUN apt update
RUN apt-cache policy docker-ce
RUN sudo apt install docker-ce -y
RUN usermod -aG docker ${NB_USER}

service docker start
service docker status

USER ${NB_USER}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
#USER ${NB_USER}


