source ./common.sh
check_root

dnf module disable nginx -y &>>$logs_file
dnf module enable nginx:1.26 -y &>>$logs_file
dnf install nginx -y &>>$logs_file
validate $? "Installing nginx"

systemctl enable nginx
systemctl start nginx
validate $? "Enable and Start nginx"

rm -rf /usr/share/nginx/html/* &>>$logs_file
validate $? "Removing default nginx content"

curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/frontend-v4.zip &>>$logs_file
cd /usr/share/nginx/html &>>$logs_file
unzip /tmp/frontend.zip &>>$logs_file
validate $? "Downloading and Unzipping frontend Code"

sed -i "s/DOMAIN_NAME/$domain_name/g" "$script_dir/roboshop.conf"
cp "$script_dir/roboshop.conf" /etc/systemd/system/roboshop.conf
validate $? "Copied roboshop Config"

nginx -t &>>$logs_file
validate $? "Nginx Configuaration"

systemctl restart nginx &>>$logs_file
validate $? "Restart nginx"

total_time