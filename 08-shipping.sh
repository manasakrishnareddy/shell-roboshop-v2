source ./common.sh
app_name=shipping
check_root

app_setup
java_setup
systemd_setup

restart
total_time