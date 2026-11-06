source ./common.sh

check_root

dnf module enable mysql:8.4 -y &>>$logs_file
dnf install mysql-server -y &>>$logs_file
validate $? "$(timestamp) [INFO] Installing mysql server"

systemctl enable mysqld &>>$logs_file
systemctl start mysqld &>>$logs_file
validate $? "$(timestamp) [INFO] Start and enable MySQL"

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "$(timestamp) [INFO] Set up MySQL root password"

total_time