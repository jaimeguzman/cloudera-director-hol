DataLakeName=$1
appID=$2
password=$3
tenID=$4
subID=$5
# Start by making sure your system is up-to-date:
sudo yum -y update
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
sudo yum check-update 
sudo yum install -y gcc libffi-devel python-devel openssl-devel
# Downloading roadshow folder in cloudera user
wget -O /home/cloudera/roadshow.zip https://aztdrepo.blob.core.windows.net/clouderadirector/roadshow.zip
unzip -o -q -d /home/cloudera/ /home/cloudera/roadshow.zip
# Downloding and installing Azure cli 2.0
curl -L https://aka.ms/InstallAzureCli | bash
az login --service-principal -u $appID --password $password --tenant $tenID
az account set --subscription $subID
#creating directories in datalake
az dls fs create --account $DataLakeName --path /roadshow --folder
az dls fs create --account $DataLakeName --path /roadshow/customers --folder
az dls fs create --account $DataLakeName --path /roadshow/departments --folder
az dls fs create --account $DataLakeName --path /roadshow/order_items --folder
az dls fs create --account $DataLakeName --path /roadshow/orders --folder
az dls fs create --account $DataLakeName --path /roadshow/original_access_logs --folder
az dls fs create --account $DataLakeName --path /roadshow/products --folder
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/categories/634a056bc2b2f165-a00fa50900000000_2023495084_data.0.parq" --destination-path "/roadshow/categories/634a056bc2b2f165-a00fa50900000000_2023495084_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/customers/2c4aa43d35536dc4-3f190a8c00000000_1758161052_data.0.parq" --destination-path "/roadshow/customers/2c4aa43d35536dc4-3f190a8c00000000_1758161052_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/departments/764c9dc54f37b5e4-c724b0fa00000000_981314998_data.0.parq" --destination-path "/roadshow/departments/764c9dc54f37b5e4-c724b0fa00000000_981314998_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/order_items/34426e89810ee31-62a8305e00000000_140984666_data.0.parq" --destination-path "/roadshow/order_items/34426e89810ee31-62a8305e00000000_140984666_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/orders/ff423f6f55f0a584-51c2a46a00000000_625278718_data.0.parq" --destination-path "/roadshow/orders/ff423f6f55f0a584-51c2a46a00000000_625278718_data.0.parq"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/original_access_logs/access.log.2" --destination-path "/roadshow/original_access_logs/access.log.2"
az dls fs upload --account $DataLakeName --source-path "/home/cloudera/roadshow/products/e0439fc50ab207a1-4314331700000000_1747318237_data.0.parq" --destination-path "/roadshow/products/e0439fc50ab207a1-4314331700000000_1747318237_data.0.parq"