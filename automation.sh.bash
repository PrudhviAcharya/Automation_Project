#update all pakages
sudo apt update 
#dpkg -s $PACKAGE_NAME > pack_info.txt

#chack if apache2 is already installed
systemctl list-units | grep "apache2"
if [ $? -eq 1 ]
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

#compress the log file present in /var/log/apache2/
tar -cvzf apache2.tgz /var/log/apache2/*.log

#install aws cli
sudo apt install awscli

#configure the aws
aws configure

#copy the files to the s3_Bucket
s3_bucket=upgrad_prudhvi
myname=prudhvi
timestamp=$(date '+%d%m%Y-%H%M%S') ) 
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar