#Start all hadoop daemons
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
$HADOOP_HOME/sbin/yarn-daemon.sh start proxyserver

#Show started daemons
$JAVA_HOME/bin/jps

#4588 SecondaryNameNode
#4033 NameNode
#3271 Main
#4795 ResourceManager
#5048 NodeManager
#5492 WebAppProxyServer
#5410 JobHistoryServer
#5562 Jps
#4278 DataNode
#3367 RemoteMavenServer
