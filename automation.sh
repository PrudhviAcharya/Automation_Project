#update all pakages
apt update
#dpkg -s $PACKAGE_NAME > pack_info.txt
#chack if apache2 is already installed
systemctl list-units | grep "apache2"
if [ $? -eq 0 ]
then
 echo "Process is running."
else
  sudo apt-get -y install apache2
fi

#check the status of the package
sudo systemctl status apache2

#check the package is enabled or not
sudo systemctl enable apache2

#check if package has started
sudo systemctl start apache2



#install aws cli
sudo apt install awscli


#copy the files to the s3_Bucket
s3_bucket=upgrad_prudhvi
myname=prudhvi
timestamp=$( (date '+%d%m%Y-%H%M%S') )
echo "$timestamp"

#compress the log file present in /var/log/apache2/
tar -cvzf /tmp/$myname-httpd-logs$timestamp.tar --exclude=other_vhosts_access.log  /var/log/apache2/*.log/apache2/*.log
tar_size=$( (du -k /tmp/${myname}-httpsd-logs-${timestamp}.tar | cut -f1) )
echo "$tar_size"
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar


#Collect the log table
inventory_file='/var/www/html/inventory.html'
if [ ! -e $inventory_file]
then
			printf "<html><body><h3>Log-Type$emsp;emsp;Time Created&emsp;&emsp;Type&emsp;emsp;Size</h3></body></html>" >> $inventory_file
			printf "<p>httpd-logs&emsp;&emsp;&emsp;$timestamp&emsp;&emsp;&emsp;tar&emsp;emsp;&emsp;$tar-size</p>" >> $inventory_file
else
			printf "<p>httpd-logs&emsp;&emsp;&emsp;$timestamp&emsp;&emsp;&emsp;tar&emsp;emsp;&emsp;$tar-size</p>" >> $inventory_file
fi


#cron job to schedule the script
cron_file='/etc/cron.d/automation'
echo "* * * * * root /root/Automation_Project/automation.sh" > $cron_file


