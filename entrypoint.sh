#!/bin/sh

# LABEL name="ye3ftp" version="1.0.1" author="palw3ey" maintainer="palw3ey" email="palw3ey@gmail.com" website="https://github.com/palw3ey/ye3ftp" license="MIT" create="20231204" update="20240224"

# Entrypoint for docker

# ============ [ function ] ============

f_log() {
  echo -e "$(date '+%Y-%m-%d %H:%M:%S') $(hostname) ye3ftp: $@"
}

# ============ [ internationalisation ] ============

# load default language
source /i18n/fr_FR.sh

# override with choosen language
if [[ $Y_LANGUAGE != "fr_FR" ]] && [[ -f /i18n/$Y_LANGUAGE.sh ]] ; then
	source /i18n/$Y_LANGUAGE.sh
fi

f_log "i18n : $Y_LANGUAGE"

# ============ [ general configuration ] ============

f_log "$i_general_configuration"
cat > /etc/vsftpd/custom.conf  <<EOF

listen=YES
listen_address=$Y_IP
listen_port=$Y_PORT
nopriv_user=vsftp
seccomp_sandbox=NO
background=YES
vsftpd_log_file=/var/log/vsftpd.log

# permission
chroot_local_user=YES
write_enable=YES
allow_writeable_chroot=YES
local_umask=000
file_open_mode=$Y_PERMISSION

# user
local_enable=YES
pam_service_name=vsftpd
session_support=YES
guest_enable=YES
guest_username=ftpuser
virtual_use_local_privs=YES
user_config_dir=/etc/vsftpd/virtual_users_config/

EOF

if [[ ! -f "/var/log/vsftpd.log" ]]; then

	f_log "$i_create_log_file"
	touch /var/log/vsftpd.log
	
fi
	
if [[ ! -d "/etc/vsftpd/virtual_users_config" ]]; then

	f_log "$i_create_virtual_user_config_directory"
	mkdir /etc/vsftpd/virtual_users_config
	
fi

# ============ [ debug ] ============

if [[ $Y_DEBUG == "yes" ]]; then

	f_log "$i_enable $i_debug"
	cat >> /etc/vsftpd/custom.conf  <<EOF
# debug
xferlog_enable=YES
xferlog_std_format=NO
log_ftp_protocol=YES
debug_ssl=YES

EOF

fi

# ============ [ passive ] ============

if [[ $Y_PASV == "yes" ]]; then

	f_log "$i_enable $i_passive"
	cat >> /etc/vsftpd/custom.conf  <<EOF
# enable passive
pasv_enable=YES
pasv_min_port=$Y_PASV_MIN
pasv_max_port=$Y_PASV_MAX

EOF
	if [[ ! -z "$Y_PASV_ADDRESS" ]]; then
		cat >> /etc/vsftpd/custom.conf  <<EOF
pasv_address=$Y_PASV_ADDRESS

EOF
	fi

else

	f_log "$i_disable $i_passive"
	cat >> /etc/vsftpd/custom.conf  <<'EOF'
# disable passive
pasv_enable=NO

EOF

fi

# ============ [ folder ] ============

if [[ $Y_INDIVIDUAL_FOLDER == "yes" ]]; then

	f_log "$i_use_individual_folder"
	cat >> /etc/vsftpd/custom.conf  <<'EOF'
# use individual folder
local_root=/data/$USER
user_sub_token=$USER

EOF
	
else

	f_log "$i_use_same_folder"
	cat >> /etc/vsftpd/custom.conf  <<'EOF'
# use same folder
local_root=/data

EOF

fi

# ============ [ anonymous ] ============

if [[ $Y_ANONYMOUS == "yes" ]]; then

	f_log "$i_enable $i_anonymous"
	cat >> /etc/vsftpd/custom.conf  <<EOF
# anonymous
anonymous_enable=YES
allow_anon_ssl=YES
chown_uploads=YES
chown_username=ftpuser

EOF

	if [[ $Y_ANONYMOUS_WRITE == "yes" ]]; then

		f_log "$i_anonymous $i_allow_write"
		cat >> /etc/vsftpd/custom.conf  <<EOF
# anonymous allow write
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES

EOF

	fi

else

	f_log "$i_disable $i_anonymous"
	cat >> /etc/vsftpd/custom.conf  <<EOF
# disable anonymous
anonymous_enable=NO
allow_anon_ssl=NO

EOF

fi

# ============ [ ssl ] ============

if [[ $Y_SSL == "yes" ]]; then
	
	if [ -f "/etc/vsftpd/fullchain.pem" ]  && [ -f "/etc/vsftpd/privkey.pem" ] ; then
	
		f_log "$i_enable ssl"
		
		vg_cert=/etc/vsftpd/fullchain.pem
		vg_key=/etc/vsftpd/privkey.pem
		
		cat >> /etc/vsftpd/custom.conf  <<EOF
# ssl
rsa_cert_file=$vg_cert
rsa_private_key_file=$vg_key
ssl_enable=YES
ssl_ciphers=HIGH
ssl_tlsv1=YES
ssl_sslv2=YES
ssl_sslv3=YES
require_ssl_reuse=NO

EOF

		if [[ $Y_SSL_FORCE == "yes" ]]; then

			f_log "$i_enable ssl $i_force"
			cat >> /etc/vsftpd/custom.conf  <<EOF
# only allow ssl
force_local_data_ssl=YES
force_local_logins_ssl=YES

EOF

		else
	
			cat >> /etc/vsftpd/custom.conf  <<EOF
# ssl optional
force_local_data_ssl=NO
force_local_logins_ssl=NO

EOF

		fi

		if [[ $Y_SSL_IMPLICIT == "yes" ]]; then

			f_log "$i_enable ssl $i_implicit"
			cat >> /etc/vsftpd/custom.conf  <<EOF
# implicit
implicit_ssl=YES

EOF

		else

			cat >> /etc/vsftpd/custom.conf  <<EOF
# explicit
implicit_ssl=NO

EOF

		fi

	fi

fi

# ============ [ user configuration ] ============

if ! id -u "ftpuser" >/dev/null 2>&1 ; then
	f_log "$i_create_user ftpuser"
    addgroup --g $Y_GID ftpgroup
	adduser -D -u $Y_UID -G ftpgroup ftpuser
	vg_password=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16; echo)
	echo $vg_password > /home/ftpuser/password
	chown root:root /home/ftpuser/password
	chmod 400 /home/ftpuser/password
	echo "ftpuser:$vg_password" | chpasswd
fi

if ! id -u "$Y_USER" >/dev/null 2>&1 ; then
	f_log "$i_create_user $Y_USER"
	adduser -D -s /sbin/nologin $Y_USER
	echo "$Y_USER:$Y_PASSWORD" | chpasswd
fi

if [[ $Y_INDIVIDUAL_FOLDER == "yes" ]]; then
	
	if [[ ! -f "/data/ftpuser" ]]; then
		f_log "$i_create_folder /data/ftpuser"
		mkdir /data/ftpuser
		chown ftpuser:ftpgroup /data/ftpuser
		chmod $Y_PERMISSION /data/ftpuser
	fi
	
	if [[ ! -f "/data/$Y_USER" ]]; then
		f_log "$i_create_folder /data/$Y_USER"
		mkdir /data/$Y_USER
		chown ftpuser:ftpgroup /data/$Y_USER
		chmod $Y_PERMISSION /data/$Y_USER
	fi
	
fi

f_log "$i_apply_permission_on_the_folder /data"
chown ftpuser:ftpgroup /data
chmod $Y_PERMISSION /data

# ============ [ start service ] ============

f_log "$i_start vsftpd"
/usr/sbin/vsftpd /etc/vsftpd/custom.conf

f_log ":: $i_ready ::"

# keep the server running
tail -f /dev/null
