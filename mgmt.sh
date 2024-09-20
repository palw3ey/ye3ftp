#!/bin/sh

# LABEL name="ye3ftp" version="1.0.0" author="palw3ey" maintainer="palw3ey" email="palw3ey@gmail.com" website="https://github.com/palw3ey/ye3ftp" license="MIT" create="20231204" update="20231204"

# This sh script help you to manage the ftp server

# ============ [ internationalisation ] ============

if [[ -f /i18n/$Y_LANGUAGE.sh ]]; then
	source /i18n/$Y_LANGUAGE.sh
else
	source /i18n/fr_FR.sh
fi

# ============ [ function ] ============

# add a new user
f_add(){

	vl_user=$1
	vl_password=$2
	
	if [ "$(f_exist $vl_user)" == "$i_user_already_exist" ]; then
		echo $i_user_already_exist
		exit 1
	fi
	
	adduser -D -s /sbin/nologin $vl_user
	echo "$vl_user:$vl_password" | chpasswd
	
	if [[ $Y_INDIVIDUAL_FOLDER == "yes" ]]; then
		mkdir /data/$vl_user
		chown ftpuser:ftpgroup /data/$vl_user
		chmod $Y_PERMISSION /data/$vl_user
	fi
	
}

# change the user password
f_update(){

	vl_user=$1
	vl_password=$2
	
	if [ "$(f_exist $vl_user)" == "$i_sorry_user_does_not_exist" ]; then
		echo $i_sorry_user_does_not_exist
		exit 1
	fi
	
	echo "$vl_user:$vl_password" | chpasswd
	
}

# delete a user
f_delete(){

	vl_user=$1
	
	if [ "$(f_exist $vl_user)" == "$i_sorry_user_does_not_exist" ]; then
		echo $i_sorry_user_does_not_exist
		exit 1
	fi
	
	deluser $vl_user
	
}

# check if a user exist
f_exist(){

	vl_user=$1
	if grep -q "^$vl_user:" /etc/passwd ; then
		echo $i_user_already_exist
	else
		echo $i_sorry_user_does_not_exist
	fi
}

# list users
f_list(){

	# human uid start at 1000
	cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1
	
}

# show log
f_log(){
	tail -f /var/log/vsftpd.log
}

# stop vsftpd
f_stop() {
	/bin/kill `/bin/ps aux | /bin/grep "/usr/sbin/vsftpd /etc/vsftpd/custom.conf" | /bin/grep -v grep | /usr/bin/awk '{ print $1 }'` > /dev/null 2>&1
}

# start vsftpd
f_start() {
	/usr/sbin/vsftpd /etc/vsftpd/custom.conf
}

# shutdown the server
f_shutdown(){
	/bin/kill `/bin/ps aux | /bin/grep "tail -f /dev/null" | /bin/grep -v grep | /usr/bin/awk '{ print $1 }'`
}

# ============ [ menu ] ============

f_arg() {
	echo -e "$(hostname -i)\n$i_HELP"
}

while [ $# -gt 0 ]; do
	case "$1" in
		--action=*|-a=*)
			action="${1#*=}"
			;;
		--user=*|-u=*)
			user="${1#*=}"
			;;
		--password=*|-p=*)
			password="${1#*=}"
			;;
		"?")
			f_arg
			exit 0
			;;
		*)
			echo -e "\n$i_error: $i_missing_or_invalid_argument"
			f_arg
			exit 1
	esac
	shift
done


case "$action" in
	"add"|"update")
		if [[ ! -z "$user" && ! -z "$password" ]]; then
			f_$action $user $password
		else 
			f_arg
		fi
	;;
	"delete"|"exist")
		if [[ ! -z "$user" ]]; then
			f_$action $user
		else 
			f_arg
		fi
	;;
	"list"|"log")
		f_$action
	;;
	"stop")
		f_stop
	;;
	"restart")
		f_stop
		f_start
	;;
	"shutdown")
		f_shutdown
	;;
	*)
		echo -e "\n$i_error: $i_missing_or_invalid_argument"
		f_arg
		exit 1
	;;
esac
