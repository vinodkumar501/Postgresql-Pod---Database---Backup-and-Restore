rm -rf *.bak
pg_dump -h 35. -U boarding boarding > 35_230_69_152_boarding_$(date +%d-%m-%y).bak
pg_dump -h 33.110.11.21 -U boarding boarding > 33_110_11_21_boarding_$(date +%d-%m-%y).bak
pg_dump -h 33.110.11.24. -U keycloak keycloak > 33_110_11_24_keycloak_$(date +%d-%m-%y).bak
pg_dump -h 33.110.11.27 -U keycloak keycloak > 33_110_11_27_keycloak_$(date +%d-%m-%y).bak
#pg_dump -h 33.110.11.26 -U keycloak keycloak > 33_110_11_26_keycloak_$(date +%d-%m-%y).bak
pg_dump -h  33.110.11.29 -U keycloak keycloak > 33_110_11_29_keycloak_$(date +%d-%m-%y).bak
pg_dump -h 33.110.11.23 -U keycloak keycloak > 33_110_11_23_keycloak_$(date +%d-%m-%y).bak

tar -czf db_backup/db_backup_$(date +%d-%m-%y).tar.gz *.bak 

find /root/db_backup  -type  f -name '*.gz' -mtime +7 -exec rm {} \;

#Notification
echo "Database Backup for LLE Completed successfully $(date +%d-%m-%y)"| mail -r"testing.gmail.com" -s "DB Backup for LLE" devteam@gmail.com qateam@gmail.com 
rm -rf *.bak

##########################################################################################
#COMPLETED script explanation


#pg_dump -h 33.110.11.29 -U keycloak keycloak > 33_110_11_29_keycloak_$(date +%d-%m-%y).bak
#O/P
#33_110_11_29_keycloak_02-02-22.bak

#pg_dump -h 33.110.11.23 -U keycloak keycloak > 33_110_11_23_keycloak_$(date +%d-%m-%y).bak
#33_110_11_23_keycloak_02-02-22.bak

#Compress all *.bak files into 1 file as tar.gz
#tar -czf db_backup/db_backup_$(date +%d-%m-%y).tar.gz *.bak 
#it takes all *.bak files created and create a tar.gz file under 

#dbbackup/db_backup_02-02-22.tar.gz  (db_backup_02-02-22.tar.gz)

