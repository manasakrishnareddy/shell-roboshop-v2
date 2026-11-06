#!/bin/bash

user_id=$(id -u)
logs_folder="/var/log/roboshop-v2"
logs_file="${logs_folder}/${0}.log"
script_dir=$(dirname "$(realpath "$0")")
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_root(){
if [ $user_id -ne 0 ]; then
    echo "Please run this script with sudo access"
    exit 1
fi
}

timestamp(){
    date "+%F %T"
}

mkdir -p $logs_folder
echo "$(timestamp) [INFO] === Script started Execution ===" | tee -a $logs_file

validate(){
    if [ $? -ne 0 ]; then
        echo -e "${2} ${R}Failed${N}"  | tee -a $logs_file
    else
        echo -e "${2} ${G}Success${N}" | tee -a $logs_file
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$logs_file
    dnf module enable nodejs:24 -y &>>$logs_file
    dnf install nodejs -y &>>$logs_file
    validate $? "$(timestamp) [INFO] Installing Nodejs 24"

    npm install &>>$logs_file
    validate $? "$(timestamp) [INFO] Installing dependencies"
}

app_setup(){
    id roboshop &>>$logs_file
    if  [ $? -ne 0 ]; then 
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$logs_file
        validate $? "$(timestamp) [INFO] Creating system user"
    else
        echo -e "$(timestamp) [INFO] System user roboshop already exist ...${Y} Skipping${N}"
    fi

    rm -rf /app
    validate $? "$(timestamp) [INFO] Removing  old code"

    mkdir -p /app
    validate $? "$(timestamp) [INFO] Creating App Directory"

    curl -L -o "/tmp/$app_name.zip" "https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/$app_name-v4.zip" &>>$logs_file
    validate $? "$(timestamp) [INFO] Downloading $app_name"

    cd /app
    unzip "/tmp/$app_name.zip"   &>>$logs_file
    validate $? "$(timestamp) [INFO] Unzipping $app_name"
}
systemd_setup(){
    sed -i "s/DOMAIN_NAME/$domain_name/g" "$script_dir/$app_name.service"
    cp "$script_dir/$app_name.service" /etc/systemd/system/$app_name.service

    systemctl daemon-reload &>>$logs_file
    systemctl enable $app_name &>>$logs_file
    systemctl start $app_name &>>$logs_file
    validate $? "$(timestamp) [INFO] Start and enabling $app_name"
}
restart()
{
    systemctl restart $app_name &>>$logs_file
    validate $? "$(timestamp) [INFO] Restarting $app_name"
}
total_time()
{
    echo "$(timestamp) [INFO] Script Completed in $SECONDS Seconds" | tee -a $logs_file
    echo "$(timestamp) [INFO] === Script Completed Execution ===" | tee -a $logs_file
}