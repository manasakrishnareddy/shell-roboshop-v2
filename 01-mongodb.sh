source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "$(timestamp) [INFO] Adding Mongo repo"

dnf install mongodb-org -y &>> $logs_file
validate $? "$(timestamp) [INFO] Install MongoDB"

systemctl enable mongod &>> $logs_file
systemctl start mongod &>> $logs_file
validate $? "$(timestamp) [INFO] Enable & start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
validate $? "$(timestamp) [INFO] Updating remote connections to mongodb"

systemctl restart mongod &>> $logs_file
validate $? "$(timestamp) [INFO] Restart MongoDB"

total_time