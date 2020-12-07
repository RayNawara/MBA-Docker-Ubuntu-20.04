# Docker Rails App

Ruby on rails development Environment.

## Docker

To build:

- run `docker-compose build`

To run:

- run `docker-compose up -d`

In another window change to your app source directory - as you can see in docker-compose.yml mine is /home/ray/mba-orig-next

Then start your IDE. I use VS Code.

```
code .
```
Make sure that gem unicorn is uncommented!

Also check out your docker network

`docker inspect rails-next-docker_default`

Back to your first window - to get into your MySQL container

- run `docker exec -it mysql /bin/bash`

To drop directly into MySQL

- run `docker exec -it mysql mysql -uroot -pMys3267!`

- run `create database mba_development;`
      `exit`

Copy the database from www1 - it's called backup05012020

```
docker exec -i mysql mysql -u root --password=Mys3267! mba_development < /mnt/d/Rays_Data/Downloads/backup05012020.sql
```

It'll take a while but you should be up with MySQL!  You may need to do docker inspect mysql to see if your ip address came out the same as mine. Remember, I used port 3307 for MySQL!

To get into your rails container

- run `docker exec -it mba_rails /bin/bash`

This will drop you into your home directory

`bundle install`

`bundle exec unicorn_rails -c config/unicorn.conf`

You should be up on localhost:8081 

To exit bash or your container:

- run `exit`

To cleanup:

- run `docker-compose down`

## Rails

Stopping the server:

- hit `ctrl-c` on your keyboard to stop the server.# MBA-Docker
