# mazadak-seald
Seald Envelop project old + new changes.

for First time setup everywhere
- copy public/.htaccess_default to public/.htaccess
- run this command to generate symlink: php artisan storage:link
- add FILESYSTEM_DRIVER=public in .env file.
- add AWS_BUCKET_FOLDER= in .env file.

------- setup on aws first time ----
- create RDS database
- Create S3 bucket named "sealed-bkt"
- run General/mazadak.sql to rds database using either cmd or mysqlworkbench.
- then run below deploymentd daily
--- Daily deployment on aws ------
- get repo and go to production branch. run below commands

docker build -t sealed-image .

docker images

## Login to AWS GUI and create RDS connection and database. add paste parameter here.
docker run -p 80:80 -d --name sealed-container --env RDS_HOSTNAME=$RDS_HOSTNAME --env RDS_DB_NAME=$RDS_DB_NAME --env RDS_USERNAME=$RDS_USERNAME --env RDS_PASSWORD=$RDS_PASSWORD sealed-image 

# local mount for development
docker run -d --name sealed-container -p 8081:81 -e  RDS_USERNAME=root -e RDS_PASSWORD=root -e RDS_DATABASE=sealed -e RDS_HOST=db --link db --network sites_default -v ${PWD}:/usr/share/nginx/html sealed-image

docker ps

=======alternatives ===
docker run -p 8081:81 -d --name sealed-container --env RDS_HOSTNAME=$RDS_HOSTNAME --env RDS_DB_NAME=$RDS_DB_NAME --env RDS_USERNAME=$RDS_USERNAME --env RDS_PASSWORD=$RDS_PASSWORD sealed-image

=== ENV keys for task definition of aws ================
RDS_HOST
RDS_DATABASE
RDS_USERNAME
RDS_PASSWORD

ENV_APP_URL

ENV_FILESYSTEM_DRIVER=s3

ENV_AWS_ACCESS_KEY_ID
ENV_AWS_SECRET_ACCESS_KEY

ENV_SMS_USERNAME=
ENV_SMS_PASSWORD=
ENV_SMS_SENDER_ID=
ENV_SMS_PURCHASECODE=

ENV_CDN_URL

ENV_MAIL_MAILER=ses or mailgun

ENV_MAIL_ENCRYPTION=SSL
ENV_MAIL_FROM_ADDRESS="info@mazadak.com"


ENV_MAILGUN_DOMAIN
ENV_MAILGUN_SECRET

ENV_APP_ENV = local or production
ENV_APP_DEBUG = true or false


===== for aws movement to registeery run below command, this will push images to container registry=====
ci-cd/build.sh version_no
Ex. ci-cd/build.sh 1.4


