#!/bin/bash -e
cd ${ENV_PATH}
echo "current dir"
pwd
echo "generate .env file from .env_server"
cp ${ENV_PATH}/.env_server ${ENV_PATH}/.env

echo "update .env file from the arguments supplied by env vars"
sed -i 's/RDS_HOST/'"$RDS_HOST"'/g' .env
sed -i 's/RDS_DATABASE/'"$RDS_DATABASE"'/g' .env
sed -i 's/RDS_USERNAME/'"$RDS_USERNAME"'/g' .env
sed -i 's/RDS_PASSWORD/'"$RDS_PASSWORD"'/g' .env

if test -n "$ENV_FILESYSTEM_DRIVER"; then
    sed -i 's/ENV_FILESYSTEM_DRIVER/'"$ENV_FILESYSTEM_DRIVER"'/g' .env
    echo "ENV_FILESYSTEM_DRIVER is set to : $ENV_FILESYSTEM_DRIVER"
else
    sed -i 's/ENV_FILESYSTEM_DRIVER/'"public"'/g' .env
fi

sed -i 's/ENV_AWS_SECRET_ACCESS_KEY/'"$ENV_AWS_SECRET_ACCESS_KEY"'/g' .env
sed -i 's/ENV_AWS_ACCESS_KEY_ID/'"$ENV_AWS_ACCESS_KEY_ID"'/g' .env
sed -i 's#ENV_APP_URL#'"$ENV_APP_URL"'#g' .env
sed -i 's#ENV_ASSET_URL#'"$ENV_ASSET_URL"'#g' .env

sed -i 's/ENV_SMS_USERNAME/'"$ENV_SMS_USERNAME"'/g' .env
sed -i 's/ENV_SMS_PASSWORD/'"$ENV_SMS_PASSWORD"'/g' .env
sed -i 's/ENV_SMS_SENDER_ID/'"$ENV_SMS_SENDER_ID"'/g' .env
sed -i 's/ENV_SMS_PURCHASECODE/'"$ENV_SMS_PURCHASECODE"'/g' .env

#sed -i 's/ENV_CDN_URL/'"$ENV_CDN_URL"'/g' .env
#for url we need to change delimeter
sed -i 's#ENV_CDN_URL#'"$ENV_CDN_URL"'#g' .env

sed -i 's/ENV_MAIL_MAILER/'"$ENV_MAIL_MAILER"'/g' .env
sed -i 's/ENV_MAIL_ENCRYPTION/'"$ENV_MAIL_ENCRYPTION"'/g' .env
sed -i 's/ENV_MAIL_FROM_ADDRESS/'"$ENV_MAIL_FROM_ADDRESS"'/g' .env

sed -i 's/ENV_MAILGUN_DOMAIN/'"$ENV_MAILGUN_DOMAIN"'/g' .env
sed -i 's/ENV_MAILGUN_SECRET/'"$ENV_MAILGUN_SECRET"'/g' .env

#this contains / slash.
sed -i 's#ENV_AWS_BUCKET_FOLDER#'"$ENV_AWS_BUCKET_FOLDER"'#g' .env

sed -i 's/ENV_APP_ENV/'"$ENV_APP_ENV"'/g' .env
 
sed -i 's/ENV_APP_DEBUG/'"$ENV_APP_DEBUG"'/g' .env

# assume we have already setup basic database and run basic sql script for first time. 
echo "composer install"
composer install

echo "Running DB Migrate"
php artisan migrate --force

echo "download lang files from s3 to local resource folder"
#download lang files from s3 to local resource folder
php artisan download:lang

echo "chmod to resource/lang"

chmod -R 0777 ${ENV_PATH}/resources/lang
echo "Running php-fpm82"
php-fpm82 && chmod 777 /var/run/php/php82-fpm.sock && chmod 755 ${ENV_PATH}/*

echo "Running ngnix daemon off"

nginx -g 'daemon off;'
