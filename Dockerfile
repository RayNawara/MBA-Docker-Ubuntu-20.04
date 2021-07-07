FROM ubuntu:20.04

LABEL description="This is an image to setup a dev environment for mbadiamond"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y \
  && apt install curl -y \
  && curl https://deb.nodesource.com/setup_15.x | bash - \
  && apt-get update \
  && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn \
  && apt-get install -y wget nano git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev 

# set rbenv, ruby-build bin paths
ENV HOME /home/app
ENV PATH $HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH
# clone rbenv
RUN git clone git://github.com/rbenv/rbenv.git ~/.rbenv
# clone ruby-build
RUN git clone git://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# RUN apt purge -y libssl-dev && apt update && apt install -y libssl1.0-dev
RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main" | tee -a /etc/apt/sources.list && apt-get update && apt install -y libssl1.0-dev # This will remove libssl-dev
RUN RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/include/openssl" rbenv install 1.8.7-p374
RUN apt install -y libssl-dev # Restore libssl-dev
RUN rbenv global 1.8.7-p374
RUN ruby -ropenssl -e 'puts OpenSSL::OPENSSL_VERSION'
RUN ruby -v
RUN gem install bundler --no-rdoc --no-ri -v 1.17.3 \
  && gem install rake --no-rdoc --no-ri -v 0.9.2 \
  && gem install rails --no-rdoc --no-ri -v 2.3.10 \
  && gem install slimgems --no-rdoc --no-ri \
  && rbenv rehash

# Set Rails to run in development
ENV RAILS_ENV development 
ENV RACK_ENV development

# install for MySql
RUN apt-get install -y -qq libmysqlclient-dev \
  # && gem install mysql2 -v 0.2.24 --no-rdoc --no-ri \
  # install for rmagick
  && apt-get install -y -qq libmagickwand-dev imagemagick

# install wkhtmltopdf 0.12.6
RUN apt-get install -y xfonts-75dpi xfonts-base
RUN apt --fix-broken install -y
RUN cd ~ && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb && dpkg -i wkhtmltox_0.12.6-1.bionic_amd64.deb && wkhtmltopdf --version

# Get MBA source from github
# RUN git init && git clone --recursive https://github.com/RayNawara/mba-orig.git 
# Change this to link to my source code directory

# set working directory to project src
WORKDIR /mba-orig

RUN pwd && bundle config mirror.https://rubygems.org http://gemstash:9292

# RUN bundle install && bundle exec unicorn_rails -c config/unicorn.conf

# You could also run script/server but then you can't generate PDFs. 

CMD ["/bin/bash"]
