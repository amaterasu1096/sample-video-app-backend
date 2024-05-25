# Introduction
This project is the backend part of a YouTube video sharing application built with Ruby on Rails.

## Key features
- Watch list shared videos
- Share video
- Vote video
- Readtime notification when new video has been shared.

# Prerequisites
- ruby 3.2.2
- rails 6.1.7.7
- sqlite

# Installation & Configuration (Using Docker)
- step 1: clone repository from github
```
git clone git@github.com:amaterasu1096/sample-video-app-backend.git
```

- step 2: build docker image
```
docker-compose build .
```

- step 3: run container
```
docker-compose up -d
```

- step 4: migrate database
```
docker-compose run --rm app bundle exec rails db:migrate
```

# Running the Application (Using Docker)
Start or stop application

```
docker-compose start
docker-compose stop
```

Application run at : `http://localhost:3001`

# Runing Unit Test
- run integration test
```
docker-compose run --rm app bundle exec rails test
```

- run rspec test
```
docker-compose run --rm app bundle exec rspec
```
