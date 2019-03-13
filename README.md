# README

## Introduction
It's a graduation project, using for RSS/ATOM Subscripting and reading.

## Requirements
* ruby 2.6.0
* bundler2
* mysql

## Commands to run
* gem update --system
* gem install bundler
* bundle install
* rails db:create
* rails db:migrate
* rails db:seed // if you need seed data
* rails server
* SIDEKIQ_THREADS=5 bundle exec sidekiq // SIDEKIQ_THREADS depends your server

## Commands to deploy
* after setting up database.yml, secrets.yml and git, you can run:
* cap production deploy

## Some issues
* Because of using uft8mb4, you need to set up this settings:
```
mysql> set global innodb_large_prefix = `ON`;
```

## License
* MIT License
