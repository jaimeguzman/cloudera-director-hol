 
DataLakedir=$1
MasterNode=$2
InputFile=$3
EndPoint=$4
DataLakeName=$5
appID=$6
password=$7
tenantID=$8
subscriptionID=$9
#Creating the Datalake Dirtectory
hadoop fs -mkdir $EndPoint/$DataLakedir
#Creating Cloudera user on hdfs cluster
sudo -u hdfs hdfs dfs -mkdir /user/cloudera
sudo -u hdfs hdfs dfs -chown cloudera:cloudera /user/cloudera
sudo -u hdfs hdfs dfs -chmod 777 /user/admin
wget -O /home/cloudera/wordcount.jar https://aztdrepo.blob.core.windows.net/clouderadirector/wordcount.jar
spark-submit --master yarn --deploy-mode client --executor-memory 1g --jars /home/cloudera/wordcount.jar --conf spark.driver.userClasspathFirst=true --conf spark.executor.extraClassPath=/home/cloudera/wordcount.jar --class com.SparkWordCount.SparkWordCount /home/cloudera/wordcount.jar hdfs://$MasterNode:8020/user/admin/$InputFile 0 $EndPoint/$DataLakedir/WordCount
#creating directories in datalake
hadoop fs -mkdir $EndPoint/roadshow
hadoop fs -mkdir $EndPoint/roadshow/categories
hadoop fs -mkdir $EndPoint/roadshow/customers
hadoop fs -mkdir $EndPoint/roadshow/departments
hadoop fs -mkdir $EndPoint/roadshow/order_items
hadoop fs -mkdir $EndPoint/roadshow/orders
hadoop fs -mkdir $EndPoint/roadshow/original_access_logs
hadoop fs -mkdir $EndPoint/roadshow/products
# Downloading roadshow folder in cloudera user
wget -O /home/cloudera/roadshow.zip https://aztdrepo.blob.core.windows.net/clouderadirector/roadshow.zip
unzip /home/cloudera/roadshow.zip 
# Start by making sure your system is up-to-date:
sudo yum update
# Compilers and related tools:
sudo yum groupinstall -y "development tools"
# Libraries needed during compilation to enable all features of Python:
sudo yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel
# If you are on a clean "minimal" install of CentOS you also need the wget tool:
sudo yum install -y wget
# Python 2.7.14:
wget http://python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz
tar xf Python-2.7.14.tar.xz
cd Python-2.7.14
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
sudo make install
yum check-update 
yum install -y gcc libffi-devel python-devel openssl-devel
# Downloding and installing Azure cli 2.0
curl -L https://aka.ms/InstallAzureCli | bash
az login --service-principal -u '$appID' --password '$password' --tenant '$tenantID'
az account set --subscription '$subscriptionID'
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/categories/634a056bc2b2f165-a00fa50900000000_2023495084_data.0.parq" --destination-path "/roadshow/categories/634a056bc2b2f165-a00fa50900000000_2023495084_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/customers/2c4aa43d35536dc4-3f190a8c00000000_1758161052_data.0.parq" --destination-path "/roadshow/customers/2c4aa43d35536dc4-3f190a8c00000000_1758161052_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/departments/764c9dc54f37b5e4-c724b0fa00000000_981314998_data.0.parq" --destination-path "/roadshow/departments/764c9dc54f37b5e4-c724b0fa00000000_981314998_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/order_items/34426e89810ee31-62a8305e00000000_140984666_data.0.parq" --destination-path "/roadshow/order_items/34426e89810ee31-62a8305e00000000_140984666_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/orders/ff423f6f55f0a584-51c2a46a00000000_625278718_data.0.parq" --destination-path "/roadshow/orders/ff423f6f55f0a584-51c2a46a00000000_625278718_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/original_access_logs/access.log.2" --destination-path "/roadshow/original_access_logs/access.log.2"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/products/e0439fc50ab207a1-4314331700000000_1747318237_data.0.parq" --destination-path "/roadshow/products/e0439fc50ab207a1-4314331700000000_1747318237_data.0.parq"