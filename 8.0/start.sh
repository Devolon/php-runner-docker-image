#!/usr/bin/env bash

if [[ -z "${WWWGROUP}" ]]; then
  WWWGROUP=1000
fi

if [[ -z "${WWWUSER}" ]]; then
  WWWUSER=1000
fi

usermod -u ${WWWUSER} application
groupmod -g ${WWWGROUP} application

php-fpm
