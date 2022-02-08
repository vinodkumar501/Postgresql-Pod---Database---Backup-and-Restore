#/bin/sh
export CLOUDSDK_CORE_DISABLE_PROMPTS=1
#Dev DB Backup
backup_public_key="/etc/cert/lle_psql_bak.pem.pub"
backup_dir="/root/backup"
backup_date=`date +%Y-%m-%d-%H-%M-%S`
DELETE="rm -f "
BUCKET="gs://lle-app"

gcloud beta container clusters get-credentials cluster-1 --region us-east1 --project cluster-16546 -q

${DELETE} ${backup_dir}/*

kubectl exec $(kubectl get po | grep -e '^dev-postgres' | head -n 1 | awk '{print $1}') -- bash -c "PGPASSWORD=admin  pg_dump -U admin -d dev-postgres" > ${backup_dir}/dev1_db_${backup_date}.sql

cat ${backup_dir}/dev1_*.sql | bzip2 | openssl smime -encrypt -aes256 -binary -outform DEM -out ${backup_dir}/dev1_${backup_date}.bz2.ssl ${backup_public_key}

gsutil cp ${backup_dir}/dev1_*.ssl ${BUCKET}/app

kubectl exec $(kubectl get po | grep -e '^keycloak-postgres' | head -n 1 | awk '{print $1}') -- bash -c "pg_dump -U admin -d keycloak" > ${backup_dir}/keycloak_db_${backup_date}.sql

cat ${backup_dir}/keycloak_*.sql | bzip2 | openssl smime -encrypt -aes256 -binary -outform DEM -out ${backup_dir}/keycloak_${backup_date}.bz2.ssl ${backup_public_key}

gsutil cp ${backup_dir}/keycloak_*.ssl ${BUCKET}/key

#Deleting 15 days old backup file

gsutil rm  ${BUCKET}/key/*
gsutil rm  ${BUCKET}/app/*

#Notification
echo "Database Backup Completed successfully $(date +%d-%m-%y)"| mail -r"dev.admin@gmail.com" -s "Dev DB Backup" dev-user@gmail.com
