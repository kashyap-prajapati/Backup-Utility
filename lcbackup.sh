#!/bin/bash
cb=1
ib=1
db=1
cbBackup=""
ibBackup=""
dbBackup=""

# complete backup for home folder
cb(){
	timestamp=$(date)
	#set the backup directory variable
	backupDir="$HOME/home/backup/cbw24"
	#set the backup log variable
	backupLog="$HOME/home/backup/backup.log" 
	#execute the command to generate complete backup excluding backup folder 
	tar -cf "$backupDir/cbw24-$cb.tar" --exclude="$HOME/home/backup/*" $HOME/*
	#update the variable for the next iteration
	#use by differential backup
	cbBackup="$backupDir/cbw24-$cb.tar" 
	# use by incremental backup
	ibBackup="$backupDir/cbw24-$cb.tar"
	#write the log into log file
	echo "$timestamp cbw24-$cb.tar was created" >>  "$backupLog"
	#increment the complete back up count
	cb=$((cb+1))
}

# incremental backup for home folder
ib(){
	#set the backup directory variable
	backupDir="$HOME/home/backup/ib24"
	#set the backup log variable
	backupLog="$HOME/home/backup/backup.log"
	#find the modified files of previous backup and current directory 
	track=$(find $HOME -type f -not -path "$HOME/home/backup/*" -newer "$ibBackup")
	# check the number of modified files
	if [ -n  "$track" ]; then
		timestamp=$(date)
		# create a backup for modified files
		tar -cf "$backupDir/ib24-$ib.tar" $track
		# update the variable for the next backup
		ibBackup="$backupDir/ib24-$ib.tar"
		# write the log into log file
		echo "$timestamp ib24-$ib.tar was created" >>  "$backupLog"
		ib=$((ib+1))
	else
		timestamp=$(date)
		echo "$timestamp no modified file so ib24-$ib.tar was not created " >>  "$backupLog"
	fi
}


# differential backup for home folder
db(){
	# set the backup directory variable
	backupDir="$HOME/home/backup/db24"
	# set the backup log variable
	backupLog="$HOME/home/backup/backup.log" 
	#find the modified files of previous backup and current directory 
	track=$(find $HOME -type f -not -path "$HOME/home/backup/*" -newer "$cbBackup")
	if [ -n  "$track" ]; then
		timestamp=$(date)
		tar -cf "$backupDir/db24-$db.tar" $track
		ibBackup="$backupDir/db24-$db.tar"
		echo "$timestamp db24-$db.tar was created" >>  "$backupLog"
		db=$((db+1))
	else
		timestamp=$(date)
		echo "$timestamp no modified file so db24-$db.tar was not created " >>  "$backupLog"
	fi
}

# check for back up directory exist or not if not create it
if [[ ! -d "$HOME/home/backup" ]]; then
	mkdir -p "$HOME/home/backup"
fi

# check for cbw24 directory exist or  not if not create it
if [[ ! -d "$HOME/home/backup/cbw24" ]]; then
	mkdir -p "$HOME/home/backup/cbw24"
fi

# check for ib24 directory exist or not, if not create it
if [[ ! -d "$HOME/home/backup/ib24" ]]; then
	mkdir -p "$HOME/home/backup/ib24"
fi

# check for db24 directory exist or not, if not create it
if [[ ! -d "$HOME/home/backup/db24" ]]; then
	mkdir -p "$HOME/home/backup/db24"
fi

# while loop infinite
while [ true ];
	do
		#call to complete back up function
		cb
		#sleep for 2 mins
		sleep 120
		#call to incremental back up function
		ib
		# sleep for 2 mins
		sleep 120
		ib
		sleep 120
		db
		sleep 120
		ib
		sleep 120
	done
