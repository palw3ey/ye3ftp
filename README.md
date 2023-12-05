# ye3ftp

A docker FTP server based on vsftpd and Alpine. Light, below 10 Mb. GNS3 ready.

The /data folder is persistent, default login: tux/1234

# Simple usage

```bash
docker run -dt --name myftp palw3ey/ye3ftp
docker exec -it myftp sh --login -c "mgmt"
```

# Advanced usage

- Map to a host folder
```bash
docker run -dt --name myftp \
  -v /home/{YOUR_USERNAME}/Downloads:/data/tux \
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

- Configure port and passive port to match your needs and according to your firewall rules
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

# GNS3

To run through GNS3, download and import the appliance : [ye3ftp.gns3a](https://raw.githubusercontent.com/palw3ey/ye3ftp/master/ye3ftp.gns3a)

# Environment Variables

These are the env variables and their default values.  

| variables | format | default |
| :- |:- |:- |
|Y_LANGUAGE | text | fr_FR |
|Y_DEBUG | yes/no | no |
|Y_IP | IP address | 0.0.0.0 |
|Y_PORT | port number | 21 |
|Y_USER | username | tux |
|Y_PASSWORD | password | 1234 |
|Y_UID | number | 1000 |
|Y_GID | number | 1000 |
|Y_PERMISSION | permission | 0775 |
|Y_INDIVIDUAL_FOLDER | yes/no | yes |
|Y_PASV | yes/no | yes |
|Y_PASV_ADDRESS | ip address |  |
|Y_PASV_MIN | port number | 0 |
|Y_PASV_MAX | port number | 0 |
|Y_ANONYMOUS | yes/no | no |
|Y_ANONYMOUS_WRITE | yes/no | no |
|Y_SSL | yes/no | no |
|Y_SSL_FORCE | yes/no | no |
|Y_SSL_IMPLICIT | yes/no | no |
|Y_DEBUG | yes/no | no |

# Build

To customize and create your own images.

```bash
git clone https://github.com/palw3ey/ye3ftp.git
cd ye3ftp
# Make all your modifications, then :
docker build --no-cache --network=host -t ye3ftp .
docker run -dt --name my_customized_ftp ye3ftp
```

# License

MIT  
author: palw3ey  
maintainer: palw3ey  
email: palw3ey@gmail.com  
website: https://github.com/palw3ey/ye3ftp  
docker hub: https://hub.docker.com/r/palw3ey/ye3ftp
