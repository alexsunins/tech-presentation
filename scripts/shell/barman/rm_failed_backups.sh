#! /bin/bash

# this script will remove backups that are reported as FAILED
# it is also possible to do the same with barman delete <server_name> oldest

target_server='my-postgres-server'
years_to_filter='2020 2021 2022 2023'

failed_backup_list=$target_server.failed-backups.txt
[[ -f $failed_backup_list ]] && $rm failed_backup_list

barman list-backup $target_server > $failed_backup_list

for y in $years_to_filter; do
  while IFS= read backup_line; do
      [[ -z $backup_line  ]] && { echo "Nothing for the year $y"; break; }

      backup_id=$(echo $backup_line | cut -d ' ' -f2 | xargs)
      barman delete $target_server $backup_id
  done <<<$(grep -i failed $failed_backup_list | grep $y | sort)
done

rm $failed_backup_list