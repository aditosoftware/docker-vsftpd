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

sed -i 's#listen=NO#listen=YES#g' /etc/vsftpd.conf
sed -i 's#listen_ipv6=YES#listen_ipv6=NO#g' /etc/vsftpd.conf
sed -i 's#anonymous_enable=NO#anonymous_enable=YES#g' /etc/vsftpd.conf
sed -i 's&#write_enable=YES&write_enable=YES&g' /etc/vsftpd.conf

echo "pasv_min_port=12020" >> /etc/vsftpd.conf
echo "pasv_max_port=12025" >> /etc/vsftpd.conf
echo "anon_root=/a/data" >> /etc/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
echo "local_umask=022" >> /etc/vsftpd.conf

chown "${FTP_USER}" /a/data

echo "INFO: ftp server is fully up and running"
vsftpd
echo "INFO: ftp server crashed"