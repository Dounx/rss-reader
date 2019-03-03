# README

## Introduction
It's a graduation project, using for RSS/ATOM Subscripting and reading.

## Requirements
* ruby 2.6.0
* rails ~> 5.2.2

## Commands to run
* bundle install
* SIDEKIQ_THREADS = 2 (Threads amount depend on your server)
* bundle exec sidekiq -r ./refresh_feeds_scheduler.rb
* rails db:migrate
* rails server