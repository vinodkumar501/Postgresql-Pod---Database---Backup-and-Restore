rm -rf *.bak
#app dev and qa
pg_dump -h *.*.*.* -U irack itrack > *_*_*_*_irack_$(date +%d-%m-%y).bak                    #*.*.*.* means ip address  # *.*.*.* --> postres service ip address.
pg_dump -h *.*.*.* -U irack itrack > *_*_*_*_irack_$(date +%d-%m-%y).bak

tar -czf db_backup/db_backup_$(date +%d-%m-%y).tar.gz *.bak

find /root/db_backup  -type  f -name '*.gz' -mtime +7 -exec rm {} \;                        #7 days retaining period.

#Notification
echo "Database Backup for LLE Completed successfully $(date +%d-%m-%y)"| mail -r"*.gmail.com" -s "DB Backup for LLE" dev.gmail.com devops.gmail.com
rm -rf *.bak






#Explanation
#*_*_*_*_irack_$(date +%d-%m-%y).bak once done it save in current folder .bak 2 files
#compress using tar and store it in db_backup folder and file name with "db_backup/db_backup_$(date +%d-%m-%y).tar.gz"
