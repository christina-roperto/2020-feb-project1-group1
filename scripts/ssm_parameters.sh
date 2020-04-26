aws ssm put-parameter --name "PROJ1_DB_USER" --value "admin$RANDOM" --type SecureString --overwrite
aws ssm put-parameter --name "PROJ1_DB_PASSWORD" --value "wdpress$RANDOM$RANDOM" --type SecureString --overwrite
