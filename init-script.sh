#!/bin/bash
yum update -y
yum -y remove httpd
yum -y remove httpd-tools
yum install -y 
#httpd24 - apache2
#php72 - Must add repo first, then install, then restart apache https://askubuntu.com/questions/1230869/cant-install-php-7-2-on-ubuntu-20-04
#mysql57-server - apt-get install mysql-server
#php72-mysqlnd - apt-get install php7.2-mysqlnd
service httpd start
chkconfig httpd on

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
cd /var/www/html
#curl http://169.254.169.254/latest/meta-data/instance-id -o index.html
#Should be in ubuntu sudo ec2metadata --instance-id | sudo tee index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terramino/master/index.php -O