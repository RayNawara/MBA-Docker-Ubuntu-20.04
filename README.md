# Docker Rails App

Ruby on rails development Environment.

## Docker

To build:

- run `docker-compose build`

To run:

- run `docker-compose up -d`

In another window change to your app source directory - as you can see in docker-compose.yml mine is /home/ray/mba-orig-next

Then start your IDE

```
code .
```
Make sure that gem unicorn is uncommented!

Also check out your docker network

`docker inspect rails-next-docker_default`

Back to your first window

- run `docker exec -it mba_rails /bin/bash`

This will drop you into your home directory

`bundle install`

`bundle exec unicorn_rails -c config/unicorn.conf`

To exit bash or your container:

- run `exit`

To cleanup:

- run `docker-compose down`

## Rails

Stopping the server:

- hit `ctrl-c` on your keyboard to stop the server.# MBA-Docker
