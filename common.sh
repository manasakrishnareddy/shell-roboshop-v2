#!/bin/bash

user_id=$(id -u)
logs_folder="/var/log/roboshop-v2"
logs_file="${logs_folder}/${0}.log"
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
total_time()
{
    echo "$(timestamp) [INFO] Script Completed in $SECONDS Seconds" | tee -a $logs_file
    echo "$(timestamp) [INFO] === Script Completed Execution ===" | tee -a $logs_file
}