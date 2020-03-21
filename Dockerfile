FROM python:latest
# its home directory will be /home/${user_inside_the_container}
ARG USER_INSIDE_THE_CONTAINER=nikolaytsanov

# To prevent prompts during build
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev openssl libev-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git \
python-pip python-dev sudo vim

RUN mkdir -p /Users/${USER_INSIDE_THE_CONTAINER}/repos

RUN useradd -rm -d /Users/${USER_INSIDE_THE_CONTAINER} -s /bin/bash -g root \
-p "$(openssl passwd -1 nikolaytsanov)" -G sudo -u 1000 ${USER_INSIDE_THE_CONTAINER}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#### # Copy the repo we're sitting in to /tmp so that we can later move it to app
#### RUN mkdir /tmp/app
#### COPY . /tmp/app

RUN chown -R ${USER_INSIDE_THE_CONTAINER}: /Users/${USER_INSIDE_THE_CONTAINER}/

USER ${USER_INSIDE_THE_CONTAINER}


# Clone and configure pyenv (i.e. pyenv's installation)
#### RUN git clone git@github.com:tsanov/youtube-dl.git /Users/${USER_INSIDE_THE_CONTAINER}/repos/
RUN git clone https://github.com/tsanov/youtube-dl.git /Users/${USER_INSIDE_THE_CONTAINER}/repos/youtube-dl
#### ENV HOME /home/${USER_INSIDE_THE_CONTAINER}
#### ENV PYENV_ROOT $HOME/.pyenv
#### ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# # Install the desired PYTHON_VERSION within pyenv
# RUN pyenv install ${PYTHON_VERSION}
# RUN pyenv global ${PYTHON_VERSION}
# RUN pyenv rehash

#### # Upgrade pip within pyenv
#### RUN pip install -U pip

#### RUN cp -r /tmp/app /home/${USER_INSIDE_THE_CONTAINER}/
# If .env has already been created copy it to home, otherwise create it
#### RUN python -c "import shutil;(shutil.os.path.isfile('app/.env') and shutil.copy('app/.env','.env')) or shutil.copy('app/.env-sample', '.env')"
#### WORKDIR /home/${USER_INSIDE_THE_CONTAINER}/app
# Source the .env file that we are ready to execute the code
#### RUN echo "" >> ~/.profile
#### RUN echo ". ~/.env" >> ~/.profile
USER root
RUN pip install --upgrade pip
WORKDIR /Users/${USER_INSIDE_THE_CONTAINER}/repos/youtube-dl
RUN pwd
RUN pip install -r requirements.txt
RUN pip install -e .
USER ${USER_INSIDE_THE_CONTAINER}

CMD ["/bin/bash"]
