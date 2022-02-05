#!/bin/sh
#
#NameNode
#
NAME_DIR=/opt/hadoop-3.2.2/data/nn

#
#DataNode
#
DATA_DIR=/opt/hadoop-3.2.2/data/dn

# Logs
HDFS_LOG_DIR=/opt/hadoop-3.2.2/logs

echo "Create namenode dir"
sudo mkdir -p $NAME_DIR
sudo chmod -R 755 $NAME_DIR

echo "Create datanode dir"
sudo mkdir -p $DATA_DIR
sudo chmod -R 755 $DATA_DIR

echo "Create log dir"
sudo mkdir -p $LOG_DIR
sudo chmod -R 755 $LOG_DIR
