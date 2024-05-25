#!/bin/bash
# Install MySQL Server
sudo apt-get update -y
# apt-cache show mysql-server
sudo apt install -y mysql-server=8.0.36-0ubuntu0.22.04.1

# Start MySQL Service
sudo service mysql start

# Set MySQL root password
MYSQL_ROOT_PASSWORD="${var.mysql_root_pass}"
# Echo variable to /home/ubuntu/mysql_root_password.txt
echo $MYSQL_ROOT_PASSWORD > /home/ubuntu/mysql_root_password.txt

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';"


# Test MySQL connection
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1"

# Create a database aka_orchestrator
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE aka_orchestrator CHARACTER SET utf8 COLLATE utf8_general_ci;"

# Check if the database aka_orchestrator is created
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"

# Create lmsUser with password and granted all privileges on aka_orchestrator except of delete
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'lmsUser'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON aka_orchestrator.* TO 'lmsUser'@'%' WITH GRANT OPTION;"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "REVOKE DROP ON aka_orchestrator.* FROM 'lmsUser'@'%';"

# # Create abc user with password and grant Object Rights, DDL Rights, Other Rights, except Grant Option
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'abc'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE TEMPORARY TABLES, TRIGGER ON aka_orchestrator.* TO 'abc'@'%';"
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "REVOKE GRANT OPTION ON aka_orchestrator.* FROM 'abc'@'%';"


# List all privileges of lmsUser
mysql -u root -p"sis@12345" -e "SHOW GRANTS FOR 'lmsUser'@'%';"

# # Configure MySQL
# sudo mysql_secure_installation <<EOF
# y
# $MYSQL_ROOT_PASSWORD
# $MYSQL_ROOT_PASSWORD
# y
# 0
# n
# n
# y EOF

# Enable MySQL Service to start on boot
sudo systemctl enable mysql