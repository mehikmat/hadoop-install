#Start all hadoop daemons
$HADOOP_HOME/sbin/stop-dfs.sh
$HADOOP_HOME/sbin/stop-yarn.sh
$HADOOP_HOME/sbin/yarn-daemon.sh stop historyserver
$HADOOP_HOME/sbin/yarn-daemon.sh stop proxyserver

#Show daemons
$JAVA_HOME/bin/jps
