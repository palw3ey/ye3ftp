# localisation file for ye3ftp
# website : https://github.com/palw3ey/ye3ftp
# language : en_GB
# translation by : palw3ey <palw3ey@gmail.com>
# create : 20231204
# update : 20231204

i_allow_write="allow write"
i_anonymous="anonymous"
i_apply_permission_on_the_folder="apply permission on the folder"
i_create_folder="create folder"
i_create_log_file="create log file"
i_create_user="create user"
i_create_virtual_user_config_directory="create virtual user config directory"
i_debug="debug"
i_disable="disable"
i_enable="enable"
i_error="error"
i_force="force"
i_general_configuration="general configuration"
i_implicit="implicit"
i_missing_or_invalid_argument="missing or invalid argument"
i_passive="passive"
i_ready="ready"
i_sorry_user_does_not_exist="sorry, user does not exist"
i_start="start"
i_use_individual_folder="use individual folder"
i_use_same_folder="use same folder"
i_user_already_exist="user already exist"
i_HELP="
--action=text
  add            : Add a new user (ARG: user, password)
  update         : Update password (ARG: user, password)
  delete         : Delete a user (ARG: user)
  exist          : Test if user exist
  list           : List all available user
  log            : Show vsftpd log
  stop           : Stop the vsftpd service
  restart        : Restart the vsftpd service
  shutdown       : Shutdown the server

--user=text      : Username
--password=text  : Password (ex: mypassword)

Example :
mgmt --action=add --user=tux2 --password=1234
"
