# ye3ftp

A docker FTP server based on vsftpd and Alpine. Light, below 10 Mb. GNS3 ready.

The /data folder is persistent, default login: tux/1234

# Simple usage

```bash
docker run -dt --name myftp palw3ey/ye3ftp
docker exec -it myftp sh --login -c "mgmt"
```

# Test

-	On the host

```bash
# create a test file :
docker exec -it myftp sh --login -c "echo it_works > /data/test.txt"
```

-   On a Linux or Windows client  

```bash
ftp
  open 192.168.9.151 21
  get test.txt
  quit

# Verify, on Linux
cat test.txt

# Verify, on Windows
type test.txt
```

On Windows, the ftp command in the terminal do not support the passive option nor the SSL option.  
To connect using these options you can use Windows explorer or the CURL command.  
For advanced use, prefer WinSCP or FileZilla.

# HOWTOs

- Add a user
```bash
docker exec -it myftp sh --login -c "mgmt --action=add --user=tux2 --password=1234"
```

- Map to a host folder
```bash
docker run -dt --name myftp \
  --net=host \
  -e Y_PORT=1022 \
  -v /home/{YOUR_USERNAME}/Documents:/data/tux \
  -e Y_USER=tux \
  -e Y_PASSWORD=strongPassword \
  palw3ey/ye3ftp
```

- Use the host Let's Encrypt certificates for SSL
```bash
docker run -dt --name myftp \
  --net=host \
  -e Y_PORT=1022 \
  -e Y_SSL=yes \
  -v /etc/letsencrypt/live/{YOUR_DOMAIN}/fullchain.pem:/etc/vsftpd/fullchain.pem \
  -v /etc/letsencrypt/live/{YOUR_DOMAIN}/privkey.pem:/etc/vsftpd/privkey.pem \
  -e Y_USER=tux \
  -e Y_PASSWORD=strongPassword \
  palw3ey/ye3ftp
```

- Configure passive port to match your needs and according to your firewall rules
```bash
docker run -dt --name myftp \
  --net=host \
  -e Y_PORT=1022 \
  -e Y_PASV_ADDRESS={YOUR_HOST_IP} \
  -e Y_PASV_MIN=40001 \
  -e Y_PASV_MAX=41000 \
  -e Y_USER=tux \
  -e Y_PASSWORD=strongPassword \
  palw3ey/ye3ftp
```
You can use "-p 1022:22" instead of "--net=host -e Y_PORT=1022", but in a PSAV scenario you will have to map every port from PASV_MIN to PASV_MAX, these -p option will create a lot of iptables rules and docker processes.

# GNS3

To run through GNS3, download and import the appliance : [ye3ftp.gns3a](https://raw.githubusercontent.com/palw3ey/ye3ftp/master/ye3ftp.gns3a)

# Environment Variables

These are the env variables and their default values.  

| variables | format | default | description |
| :- |:- |:- |:- |
|Y_LANGUAGE | text | fr_FR | Language. The list is in the folder /i18n/ |
|Y_DEBUG | yes/no | no | yes, Run vsftpd with debug option |
|Y_IP | IP address | 0.0.0.0 | IP address to listen to |
|Y_PORT | port number | 21 | Port to listen to |
|Y_USER | username | tux | The user to create |
|Y_PASSWORD | password | 1234 | The password for the user |
|Y_UID | number | 1000 | The UID to use for all FTP users |
|Y_GID | number | 1000 | The GID to use for all FTP users |
|Y_PERMISSION | permission | 0775 | *file_open_mode* |
|Y_INDIVIDUAL_FOLDER | yes/no | yes | yes, All user use a personal folder. |
|Y_PASV | yes/no | yes | yes, to enable PASV. *pasv_enable*  |
|Y_PASV_ADDRESS | ip address |  | *pasv_address* |
|Y_PASV_MIN | port number | 0 | *pasv_min_port* |
|Y_PASV_MAX | port number | 0 | *pasv_max_port* |
|Y_ANONYMOUS | yes/no | no | yes, to allow anonymous logins. Anonymous usernames are : ftp and anonymous |
|Y_ANONYMOUS_WRITE | yes/no | no | yes, to allow anonymous to write|
|Y_SSL | yes/no | no | yes, to enable SSL. Require /etc/vsftpd/fullchain.pem and /etc/vsftpd/privkey.pem |
|Y_SSL_FORCE | yes/no | no | yes, to allow only SSL connections | 
|Y_SSL_IMPLICIT | yes/no | no | *implicit_ssl* |

# Build

To customize and create your own images.

```bash
git clone https://github.com/palw3ey/ye3ftp.git
cd ye3ftp
# Make all your modifications, then :
docker build --no-cache --network=host -t ye3ftp .
docker run -dt --name my_customized_ftp ye3ftp
```

# Documentation

[vsftpd man page](https://linux.die.net/man/5/vsftpd.conf)

# Version

| name | version |
| :- |:- |
|ye3ftp | 1.0.0 |
|vsftpd | 3.0.5 |
|alpine | 3.18.4 |

# ToDo

- ~~need to document env variables~~ (2023-12-18)
- add more translation files in i18n folder. Contribute ! Send me your translations by mail ;)

Don't hesitate to send me your contributions, issues, improvements on github or by mail.

# License

MIT  
author: palw3ey  
maintainer: palw3ey  
email: palw3ey@gmail.com  
website: https://github.com/palw3ey/ye3ftp  
docker hub: https://hub.docker.com/r/palw3ey/ye3ftp
