source ./common.sh

check_root

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo 
validate $? "$(timestamp) [INFO] Adding rabbitmq repo" 

dnf install erlang rabbitmq-server -y &>>$logs_file
validate $? "$(timestamp) [INFO] Installing rabbitmq" 

systemctl enable rabbitmq-server  &>>$logs_file
systemctl start rabbitmq-server &>>$logs_file
validate $? "$(timestamp) [INFO] Start and Enable of rabbitmq server" 

rabbitmqctl list_users | grep -qw "roboshop"
if [ $? -ne 0 ]; then 
    rabbitmqctl add_user roboshop roboshop123 &>>$logs_file
    validate $? "$(timestamp) [INFO] Creating Rabbitmq user for roboshop" 
else
    echo -e "$(timestamp) [INFO] RabbitMQ user already exist ${Y}Skipping${N}"
fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$logs_file
validate $? "$(timestamp) [INFO] Setting permissions for Rabbitmq user" 

total_time