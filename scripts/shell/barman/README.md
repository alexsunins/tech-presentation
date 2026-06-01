# Barman

This script will remove backups that are reported as FAILED.
It is also possible to do the same with

```bash
barman delete <server_name> oldest
```

The script was designed to be run as a cron job.
