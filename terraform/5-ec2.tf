# Windows vm_1 Private Subnet
resource "aws_instance" "vm_1" {
  ami           = "ami-06cc514f1012a7431" # windows server 2019
  instance_type = "t3.small" 
  key_name      = "${var.key_name}"
  # get_password_data = true
  vpc_security_group_ids = ["${aws_security_group.public_sg.id}"]
  subnet_id              = aws_subnet.public_subnet.id

  iam_instance_profile = aws_iam_instance_profile.profile.name

  user_data = base64encode(file("${"init.txt"}"))

  tags = {
    Name = "${var.project_prefix}_${var.env_prefix}_private_vm_1"
  }

  # root_block_device {
  #   volume_size = 100
  # }
  # depends_on = [ aws_nat_gateway.nat_gateway ]
}

# Windows vm_2 Public Subnet
# resource "aws_instance" "vm_2" {
#   ami           = "ami-06cc514f1012a7431" # windows server 2019
#   instance_type = "t3.small" # "t3.xlarge"
#   key_name      = "${var.key_name}"
#   # get_password_data = true
#   vpc_security_group_ids = ["${aws_security_group.public_sg.id}"]
#   subnet_id              = aws_subnet.public_subnet.id

#   iam_instance_profile = aws_iam_instance_profile.profile.name

#   user_data = base64encode(file("${"init.txt"}"))

#   tags = {
#     Name = "${var.project_prefix}_${var.env_prefix}_public_vm_2"
#   }

#   # root_block_device {
#   #   volume_size = 100
#   # }
#   depends_on = [ aws_internet_gateway.igw ]
# }

# # Linux Ubuntu MySQL vm_1 Private Subnet
# resource "aws_instance" "private_vm_ubuntu_mysql" {
#   ami           = "ami-080e1f13689e07408"
#   instance_type = "t2.micro"
#   key_name      = "${var.key_name}"
  
#   vpc_security_group_ids = ["${aws_security_group.private_sg.id}"]
#   subnet_id              = aws_subnet.private_subnet.id

#   # user_data     = "${file("ec2-user-data.sh")}"
# #   user_data = <<-EOF
# # #!/bin/bash
# # sudo -su ubuntu
# # cd /home/ubuntu

# # # Update the package list
# # sudo apt-get update -y

# # # Install AWS CLI
# # curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# # sudo apt install unzip -y
# # unzip awscliv2.zip
# # sudo ./aws/install
# # # /usr/local/bin/aws --version
# # aws --version

# # # Pull nat_mysql/dev/mysql/password secret from AWS Secrets Manager
# # # aws secretsmanager get-secret-value --secret-id ${var.project_prefix}/${var.env_prefix}/mysql/password
# # # aws secretsmanager get-secret-value --secret-id nat_mysql/dev/mysql/password

# # # Pull nat_mysql/dev/mysql/password secret from AWS Secrets Manager, get SecretString from output json and create a MYSQL_ROOT_PASSWORD
# # MYSQL_ROOT_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${var.project_prefix}/${var.env_prefix}/mysql/password --query SecretString --output text)
# # # MYSQL_ROOT_PASSWORD=$(aws secretsmanager get-secret-value --secret-id nat_mysql/dev/mysql/password --query SecretString --output text)

# # # Install MySQL Server
# # # apt-cache show mysql-server
# # sudo apt install -y mysql-server=8.0.36-0ubuntu0.22.04.1

# # # Start MySQL Service
# # sudo service mysql start

# # # Enable MySQL Service to start on boot
# # sudo systemctl enable mysql

# # # MySQL allow remote connections
# # sudo sed -i '$a bind-address = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf

# # # Restart MySQL Service
# # sudo service mysql restart

# # # Set MySQL root password
# # # MYSQL_ROOT_PASSWORD="${data.aws_secretsmanager_secret_version.db_password_version.secret_string}"
# # echo $MYSQL_ROOT_PASSWORD > /home/ubuntu/mysql_root_password_1.txt

# # # Set MySQL root password
# # sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';"

# # # Test MySQL connection
# # mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1"

# # # Create a database aka_orchestrator
# # mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE aka_orchestrator CHARACTER SET utf8 COLLATE utf8_general_ci;"

# # # Check if the database aka_orchestrator is created
# # mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"

# # # Create lmsUser with password and granted all privileges on aka_orchestrator database
# # mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'lmsUser'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
# # mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON aka_orchestrator.* TO 'lmsUser'@'%';"

# # # List all privileges of lmsUser 
# # mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW GRANTS FOR 'lmsUser'@'%';"

# # # List all MySQL users with
# # mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT User FROM mysql.user;"

# # EOF

#   # user_data_replace_on_change = true

#   iam_instance_profile = aws_iam_instance_profile.profile.name

#   tags = {
#     Name = "${var.project_prefix}_${var.env_prefix}_private_vm_ubuntu_mysql"
#   }
# }


