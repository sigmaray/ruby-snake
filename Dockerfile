FROM theasp/novnc:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && \
    apt-get install -qy procps curl ca-certificates gnupg2 build-essential --no-install-recommends && apt-get clean

# RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
# RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 3.2.2"

# RUN gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# RUN \curl -L https://get.rvm.io | bash -s stable
# RUN /bin/bash -l -c "rvm requirements"

# RUN apt-get update -qq && apt-get update && apt-get install -y python3-pyqt5 python3-pip

# RUN apt-get update -q && \
#     apt-get install -qy gnome-terminal sakura

RUN apt-get install -qy lxterminal

# RUN echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc
# RUN echo 'source /etc/profile.d/rvm.sh' >> /etc/profile

WORKDIR /game

# COPY requirements.txt .

# RUN pip install -r requirements.txt 

COPY . .

RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && cd curses && bundle install"

# RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && cd gtk && bundle install"
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && cd gtk && gem install gtk3 && bundle install"

RUN echo 'source /etc/profile.d/rvm.sh' >> /root/.bashrc

RUN apt-get install -qy default-jdk

RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install jruby-9.4.5.0"
