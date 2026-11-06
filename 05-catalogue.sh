source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup

cp "$script_dir/mongo.repo" /etc/yum.repos.d/mongo.repo
validate $? "$(timestamp) [INFO] Adding Mongo repo"

dnf install mongodb-mongosh -y &>>$logs_file
validate $? "$(timestamp) [INFO] Installing MongoDB Client" 

product_count=$(mongosh --host "mongodb.$domain_name" --quiet --eval 'db.getSiblingDB("catalogue").products.countDocuments()' 2>>$logs_file)
validate $? "$(timestamp) [INFO] Connecting to MongoDB"

if [ $product_count -eq 0 ]; then
    mongosh --host "mongodb.$domain_name" </app/db/master-data.js &>>$logs_file
    validate $? "$(timestamp) [INFO] Loading Products"
else    
    echo -e "$(timestamp) [INFO] Products are already loaded ..${Y}Skipping${N}"
fi

restart
total_time