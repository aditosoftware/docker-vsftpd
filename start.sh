#!/bin/sh

if [ ! -f /etc/vsftpd.conf~ ]
  then
    cp -f /etc/vsftpd.conf /etc/vsftpd.conf~
  else
    cp -f /etc/vsftpd.conf~ cp /etc/vsftpd.conf
fi

rm -rf "/home/*"
ln -sf /a/data "/home/${FTP_USER}"

useradd --shell /bin/sh "${FTP_USER}"
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

cat > /etc/vsftpd.conf << EOF

listen=YES
listen_ipv6=NO
anonymous_enable=YES
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
pasv_address=$PASV_IP
pasv_min_port=$PPORT_MIN
pasv_max_port=$PPORT_MAX
anon_root=/a/data
allow_writeable_chroot=YES
local_umask=022

EOF

chown "${FTP_USER}" /a/data

echo "INFO: ftp server is fully up and running"
vsftpd
echo "INFO: ftp server crashed"