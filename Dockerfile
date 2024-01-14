FROM theasp/novnc:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && \
    apt-get install -qy procps curl ca-certificates gnupg2 build-essential default-jdk --no-install-recommends && apt-get clean

RUN curl -sSL https://get.rvm.io | bash -s
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 3.2.2 && rvm install jruby-9.4.5.0"

RUN echo 'source /etc/profile.d/rvm.sh' >> /root/.bashrc

WORKDIR /game

COPY . .

# Running bundle install as root is bad, but in this project Docker is used only for demonstration purposes.
# So in this particular case doing bundle install as root is ok.

RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && cd curses && bundle install"

# I have no idea why it's necessary to do "gem install gtk3 " before "bundle install" and have no time
# to investigate this problem
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && cd gtk && gem install gtk3 && bundle install"

RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install jruby-9.4.5.0"
