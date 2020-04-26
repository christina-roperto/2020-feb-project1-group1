#!/bin/bash
if ! aws ssm get-parameter --name "PROJ1_DB_USER"
then
    aws ssm put-parameter --name "PROJ1_DB_USER" --value "admin$RANDOM" --type SecureString
fi

if ! aws ssm get-parameter --name "PROJ1_DB_PASSWORD"
then
    aws ssm put-parameter --name "PROJ1_DB_PASSWORD" --value "wdpress$RANDOM$RANDOM" --type SecureString
fi