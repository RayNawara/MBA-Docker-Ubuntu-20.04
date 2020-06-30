FROM ubuntu:16.04

LABEL description="This is an image to setup a dev environment for mbadiamond"

RUN apt-get update && apt-get install -y
RUN apt-get install -qq -y wget git-core curl unzip zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs

# set rbenv, ruby-build bin paths
ENV HOME /home/app
ENV PATH $HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH
# clone rbenv
RUN git clone git://github.com/rbenv/rbenv.git ~/.rbenv
# clone ruby-build
RUN git clone git://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN apt-get install make
RUN cd /usr/local/src/ && wget https://www.openssl.org/source/openssl-1.0.2u.tar.gz \
  && tar -xzvf openssl-1.0.2u.tar.gz \
  && cd openssl-1.0.2u \
  && openssl version -a \
  && ./config \
  && make install \
  && ln -sf /usr/local/ssl/bin/openssl `which openssl` \
  && openssl version -v

# RUN apt purge -y libssl-dev && apt install -y libssl1.0-dev
RUN rbenv install 1.8.7-p374 \
  && rbenv global 1.8.7-p374 \
  && ruby -v \
  && gem install bundler --no-rdoc --no-ri -v 1.17.1 \
  && gem install rake --no-rdoc --no-ri -v 0.9.2 \
  && gem install rails --no-rdoc --no-ri -v 2.3.18 \
  && gem install slimgems --no-rdoc --no-ri \
  && rbenv rehash

# Set Rails to run in development
ENV RAILS_ENV development 
ENV RACK_ENV development

# install for MySql
RUN apt-get install -y -qq libmysqlclient-dev \
  && gem install mysql -v 2.8.1 --no-rdoc --no-ri

# install for rmagick
RUN apt-get install -y -qq libmagickwand-dev imagemagick

# install wkhtmltopdf 0.12.3
RUN cd ~ && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && cp wkhtmltox/bin/wk* /usr/local/bin/ && wkhtmltopdf --version

# Get MBA source from github
# RUN git init && git clone --recursive https://github.com/RayNawara/mba-orig.git 
# Change this to link to my source code directory

# set working directory to project src
WORKDIR /mba-orig

# RUN bundle install && bundle exec unicorn_rails -c config/unicorn.conf

# You could also run script/server but then you can't generate PDFs. 

CMD ["/bin/bash"]
