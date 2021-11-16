#!/bin/bash

# サービスの存在と有効ステータスを確認
service1="zabbix-agent"

echo "--------------------------------------------------------------"
echo "[Step1] sudo systemctl list-unit-files | grep ${service1}"
sudo systemctl list-unit-files | grep ${service1}
service1_res=`sudo systemctl list-unit-files | grep ${service1}`
service1_enebled_status=`sudo systemctl list-unit-files | grep ${service1} | awk '{printf("%s", $2)}'`
if [[ "$service1" == "" ]]; then
    echo "Error: Systemd unit \"${service1}\" not found."
fi


# サービスの起動ステータスを確認
echo "--------------------------------------------------------------"
echo "[Step2] sudo systemctl status ${service1}"
sudo systemctl status ${service1}
service1_status=`sudo systemctl status ${service1} | grep Active: | sed -r 's/^\s*Active:\s(.*\(.*\)).*$/\1/g'`
if [[ "$service1_status" != "active (running)" ]]; then
    echo "Error: \"${service1}\" is not running."
else
    echo "Info: \"${service1}\" is running!!"
    exit
fi

# Unitファイルのパスを取得する
service1_unit=`sudo systemctl status ${service1} | grep Loaded | sed -r "s/^.*(\/usr\/lib\/systemd\/system\/.*service).*$/\1/"`
# UserとGroupを取得する
service1_user=`grep User /usr/lib/systemd/system/${service1}.service | sed -r 's/^.*=([a-zA-Z0-9]*)$/\1/g'`
service1_group=`grep Group /usr/lib/systemd/system/${service1}.service | sed -r 's/^.*=([a-zA-Z0-9]*)$/\1/g'`
service1_piddir=`grep PIDFile /usr/lib/systemd/system/${service1}.service | sed -r 's/^.*=([a-zA-Z0-9_\/-\.]*\/).*$/\1/g'`
service1_pidfile=`grep PIDFile /usr/lib/systemd/system/${service1}.service | sed -r 's/^.*=([a-zA-Z0-9_\/-\.]*)$/\1/g'`

# PIDファイルの場所を確認する
echo "Service User: ${service1_user}"
echo "Service Group: ${service1_group}"
echo "Service PID Directory: ${service1_piddir}"
echo "Service PID file: ${service1_pidfile}"


# PID情報を格納するディレクトリが存在することを確認
echo "--------------------------------------------------------------"
echo "[Step3] sudo ls -l ${service1_piddir}"
sudo ls -l ${service1_piddir}
service1_dir_perm=`sudo ls -l ${service1_piddir} | awk '{printf("%s", $1)}'`
service1_dir_user=`sudo ls -l ${service1_piddir} | awk '{printf("%s", $2)}'`
service1_dir_group=`sudo ls -l ${service1_piddir} | awk '{printf("%s", $3)}'`

echo "--------------------------------------------------------------"
echo "[Step4] sudo ls -l ${service1_pidfile}"
sudo ls -l ${service1_pidfile}
service1_file_perm=`sudo ls -l ${service1_pidfile} | awk '{printf("%s", $1)}'`
service1_file_user=`sudo ls -l ${service1_pidfile} | awk '{printf("%s", $2)}'`
service1_file_group=`sudo ls -l ${service1_pidfile} | awk '{printf("%s", $3)}'`


# PID取得
echo "--------------------------------------------------------------"
echo "[Step5] cat ${service1_pidfile}"
cat ${service1_pidfile}
service1_pid=`cat ${service1_pidfile}`

echo "Service PID: ${service1_pid}"
echo "Inspect /proc/${service1_pid} for more information."