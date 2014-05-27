#!/bin/sh

#
# Users and Groups
# it is best to run the various daemons with separate accounts
#

# User which will own the HDFS services.
HDFS_USER=hdfs

# User which will own the YARN services.
YARN_USER=yarn

# User which will own the MapReduce services.
MAPRED_USER=mapred

# A common group shared by services.
HADOOP_GROUP=hadoop

# For Ubuntu
echo "Create group hadoop"
sudo groupadd $HADOOP_GROUP

#######################################################################
echo "Create user hdfs"
sudo useradd -G $HADOOP_GROUP $HDFS_USER
echo "Create hdfs user home dir"
sudo mkdir -p /home/hdfs
sudo chmod -R 700 /home/hdfs
sudo chown -R hdfs:hadoop /home/hdfs
cat << EOF | sudo -u hdfs ssh-keygen



EOF
sudo -u hdfs sh -c "cat /home/hdfs/.ssh/id_rsa.pub >> /home/hdfs/.ssh/authorized_keys"

#########################################################################
echo "Create user yarn"
sudo useradd -G $HADOOP_GROUP $YARN_USER
echo "Create yarn user home dir"
sudo mkdir -p /home/yarn
sudo chmod -R 700 /home/yarn
sudo chown -R yarn:hadoop /home/yarn
cat << EOF | sudo -u yarn ssh-keygen



EOF
sudo -u yarn sh -c "cat /home/yarn/.ssh/id_rsa.pub >> /home/yarn/.ssh/authorized_keys"

###########################################################################
echo "Create user mapred"
sudo useradd -G $HADOOP_GROUP $MAPRED_USER
echo "Create mapred user home dir"
sudo mkdir -p /home/mapred
sudo chmod -R 700 /home/mapred
sudo chown -R mapred:hadoop /home/mapred
cat << EOF | sudo -u mapred ssh-keygen



EOF
sudo -u mapred sh -c "cat /home/mapred/.ssh/id_rsa.pub >> /home/mapred/.ssh/authorized_keys"