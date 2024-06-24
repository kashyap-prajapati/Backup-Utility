#!/bin/bash

# backup home directory
backup_home="$HOME/home/backup"
# backup log file
backup_log="$HOME/home/backup/backup.log"
# complete backup directory
cb_backup_dir="$HOME/home/backup/cbw24"
# incremental backup directory
ib_backup_dir="$HOME/home/backup/ib24"
# differential backup directory
db_backup_dir="$HOME/home/backup/db24"
# counts for each backup to generate log on rolling basis
cb_count=1
ib_count=1
db_count=1
cb_backup=""
ib_backup=""
db_backup=""

# function for creating complete backup of the directory rooted at the /home/username 
# also exclude backup directory folder so we are not crearing the backup of backup folder.
complete_backup(){
	timestamp=$(date)
	# execute the tar command
	tar -cf "$cb_backup_dir/cbw24-$cb_count.tar" --exclude="$backup_home/*" $HOME/*
	cb_backup="$cb_backup_dir/cbw24-$cb_count.tar"
	ib_backup="$cb_backup_dir/cbw24-$cb_count.tar"
	#write into the log file
	echo "$timestamp cbw24-$cb_count.tar created" >>  "$backup_log"
	cb_count=$((cb_count+1))
}

# function for creating incremental backup of the current directory - previoud backup
incremental_backup(){
	# find command to track any modified files or new files
	track=$(find $HOME -type f -not -path "$backup_home/*" -newer "$ib_backup")
	if [ -n  "$track" ]; then
		timestamp=$(date)
		# execute the tar command
		tar -cf "$ib_backup_dir/ib24-$ib_count.tar" $track
		ib_backup="$ib_backup_dir/ib24-$ib_count.tar"
		# write into the log file
		echo "$timestamp ib24-$ib_count.tar was created" >>  "$backup_log"
		ib_count=$((ib_count+1))
	else
		timestamp=$(date)
		# no incremental backup was created
		echo "$timestamp No changes-incremental backup was not created" >>  "$backup_log"
	fi
}

# function for creating differential backup of the current directory -  previoud complete backup diretory
differential_backup(){
	# find command to track any modified files or new files
	track=$(find $HOME -type f -not -path "$backup_home/*" -newer "$cb_backup")
	if [ -n  "$track" ]; then
		timestamp=$(date)
		tar -cf "$db_backup_dir/db24-$db_count.tar" $track
		ib_backup="$db_backup_dir/db24-$db_count.tar"
		# write into the log file
		echo "$timestamp db24-$db_count.tar was created" >>  "$backup_log"
		db_count=$((db_count+1))
	else
		timestamp=$(date)
		# no incremental backup was created
		echo "$timestamp No changes-differential backup was not created" >>  "$backup_log"
	fi
}


# make sure that backup home exists or not
if [[ ! -d "$backup_home" ]]; then
	mkdir -p "$backup_home"
fi

# make sure that complete backup directory exists or not
if [[ ! -d "$cb_backup_dir" ]]; then
	mkdir -p "$cb_backup_dir"
fi

# make sure that incremental backup directory exists or not
if [[ ! -d "$ib_backup_dir" ]]; then
	mkdir -p "$ib_backup_dir"
fi

# make sure that differential backup directory exists or not
if [[ ! -d "$db_backup_dir" ]]; then
	mkdir -p "$db_backup_dir"
fi

while [ true ];
	do
		complete_backup
		sleep 90
		incremental_backup
		sleep 90
		incremental_backup
		sleep 90
		differential_backup
		sleep 90
		incremental_backup
		sleep 90
	done
