#!/bin/sh
set -e

cd $(ls -d */|head -n 1)
cp public/index.php public/php81RC6.php
sed -i "s/(new Dotenv())->bootEnv(dirname(__DIR__).'\/.env');/(new Dotenv())->bootEnv(dirname(__DIR__).'\/.env');(new Dotenv())->overload(dirname(__DIR__).'\/.env');/g" public/php81RC6.php

MAILER_DSN=$(symfony var:export MAILER_DSN)
MAILER_DSN=$(echo $MAILER_DSN | sed -e 's/127.0.0.1/host.docker.internal/g')
DATABASE_URL=$(symfony var:export DATABASE_URL)
DATABASE_URL=$(echo $DATABASE_URL | sed -e 's/127.0.0.1/host.docker.internal/g')

touch .env.dev.local
if [[ "$(cat .env.dev.local | grep MAILER_DSN | head -1)" = "" ]]
then
  echo "MAILER_DSN=$MAILER_DSN" >> .env.dev.local
else
  sed -i "s#.*MAILER_DSN.*#MAILER_DSN=$MAILER_DSN#g" .env.dev.local
fi

if [[ "$(cat .env.dev.local | grep DATABASE_URL | head -1)" = "" ]]
then
  echo "DATABASE_URL=$DATABASE_URL" >> .env.dev.local
else
  DATABASE_URL=$(echo $DATABASE_URL | sed -e 's/\&/\\&/g')
  sed -i "s#.*DATABASE_URL.*#DATABASE_URL=$DATABASE_URL#g" .env.dev.local
fi

if [[ "$(cat .gitignore | grep php81RC6 | head -1)" = "" ]]
then
  echo "" >> .gitignore
  echo "####> Yoann-TYT/sfindocker ####" >> .gitignore
  echo "/public/php81RC6.php" >> .gitignore
  echo "####< Yoann-TYT/sfindocker ####" >> .gitignore
fi

symfony serve --passthru=php81RC6.php
