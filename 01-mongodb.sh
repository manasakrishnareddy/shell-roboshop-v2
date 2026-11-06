source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding Mongo repo"

dnf install mongodb-org -y &>> $logs_file
validate $? "Install MongoDB"

systemctl enable mongod &>> $logs_file
systemctl start mongod &>> $logs_file
validate $? "Enable & start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
validate $? "Updating remote connections to mongodb"

systemctl restart mongod &>> $logs_file
validate $? "Restart MongoDB"

total_time