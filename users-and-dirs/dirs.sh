#!/bin/sh

#
# Directories Script
#

#
# Users and Groups
#

# User which will own the HDFS services.
HDFS_USER=hdfs

# User which will own the YARN services.
YARN_USER=yarn

# User which will own the MapReduce services.
MAPRED_USER=mapred

# A common group shared by services.
HADOOP_GROUP=hadoop

#
# Hadoop Service - HDFS
#

# Space separated list of directories where NameNode will store file system image.
# For example, /grid/hadoop/hdfs/nn /grid1/hadoop/hdfs/nn
DFS_NAME_DIR=/hadoop/hdfs/nn

# Space separated list of directories where DataNodes will store the blocks.
# For example, /grid/hadoop/hdfs/dn /grid1/hadoop/hdfs/dn
DFS_DATA_DIR=/hadoop/hdfs/dn

# Directory to store the HDFS logs.
HDFS_LOG_DIR=/var/log/hadoop/hdfs

# Directory to store the HDFS process ID.
HDFS_PID_DIR=/var/run/hadoop/hdfs

#
# Hadoop Service - YARN 
#

# Space separated list of directories where YARN will store temporary data.
# For example, /grid/hadoop/yarn/local /grid1/hadoop/yarn/local
YARN_LOCAL_DIR=/hadoop/yarn/local

# Directory to store the YARN logs.
YARN_LOG_DIR=/var/log/hadoop/yarn

# Space separated list of directories where YARN will store container log data.
# For example, /grid/hadoop/yarn/logs /grid1/hadoop/yarn/logs
YARN_LOCAL_LOG_DIR=/hadoop/yarn/logs

# Directory to store the YARN process ID.
YARN_PID_DIR=/var/run/hadoop/yarn

#
# Hadoop Service - MAPREDUCE
#

# Directory to store the MapReduce daemon logs.
MAPRED_LOG_DIR=/var/log/hadoop/mapred

# Directory to store the mapreduce jobhistory process ID.
MAPRED_PID_DIR=/var/run/hadoop/mapred


echo "Create namenode dir"
sudo mkdir -p $DFS_NAME_DIR
sudo chmod -R 755 $DFS_NAME_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $DFS_NAME_DIR

echo "Create datanode dir"
sudo mkdir -p $DFS_DATA_DIR
sudo chmod -R 755 $DFS_DATA_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $DFS_DATA_DIR

echo "Create hdfs log dir"
sudo mkdir -p $HDFS_LOG_DIR
sudo chmod -R 755 $HDFS_LOG_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_LOG_DIR

echo "Create hdfs pid dir"
sudo mkdir -p $HDFS_PID_DIR
sudo chmod -R 777 $HDFS_PID_DIR
sudo chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_PID_DIR

echo "Create yarn local dir"
sudo mkdir -p $YARN_LOCAL_DIR
sudo chmod -R 755 $YARN_LOCAL_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_DIR

echo "Create yarn local log dir"
sudo mkdir -p $YARN_LOCAL_LOG_DIR
sudo chmod -R 755 $YARN_LOCAL_LOG_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_LOG_DIR

echo "Create yarn log dir"
sudo mkdir -p $YARN_LOG_DIR
sudo chmod -R 755 $YARN_LOG_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOG_DIR

echo "Create yarn pid dir"
sudo mkdir -p $YARN_PID_DIR
sudo chmod -R 777 $YARN_PID_DIR
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_PID_DIR

echo "Create mapreduce log dir"
sudo mkdir -p $MAPRED_LOG_DIR
sudo chmod -R 755 $MAPRED_LOG_DIR
sudo chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_LOG_DIR

echo "Create mapreduce pid dir"
sudo mkdir -p $MAPRED_PID_DIR
sudo chmod -R 777 $MAPRED_PID_DIR
sudo chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_PID_DIR