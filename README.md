Apache Hadoop 3.2.2
=============================
####Prerequisites
- Supported Operating Systems: GNU/Linux.
- Supported JDK Versions: >= jdk-8.
- Supported Internet Protocol: IPv4.
- SSH configuration: Password less SSH should be configured.

###Installing Hadoop on a Single Linux Node in Pseudo-distributed Mode

For development purpose, Apache Hadoop components can be deployed on a single Linux node in pseudo-distributed mode.
In pseudo-distributed mode, Hadoop processing is distributed over all of the cores/processors on a single machine. 
Hadoop writes all files to the Hadoop Distributed File System (HDFS), and all services and daemons communicate
over local TCP sockets for inter-process communication.

###STEP-1
```
Download Apache Hadoop tarball
$ cd /opt
$ wget https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
$ tar -xzf hadoop-3.2.2.tar.gz
$ cd hadoop-3.2.2
```

###STEP-2
Create required directories and environment variables. Hadoop Requires directories for name node and data nodes.

```
$ git clone https://github.com/mehikmat/hadoop-install.git
$ cd hadoop-install
$ ./create_dirs.sh
```

_Export environment variables. Edit ~/.bashrc_  and add

```
export HADOOP_HOME=/opt/hadoop-3.2.2.tar.gz
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```

#####Refresh bash profile `$ bash`

###STEP-3

_Edit config files_
 - core-site.xml
 - hdfs-site.xml
 - mapred-site.xml
 - yarn-site.xml
 - hadoop-env.sh
 - yarn-env.sh
 - mapred-env.sh
 
    OR

```
$ git clone https://github.com/mehikmat/hadoop-install.git
$ cp -R hadoop-install/etc/hadoop/* $HADOOP_HOME/etc/hadoop/
```

###STEP-4

Format namenode
```
$ hadoop namenode -format 
```

###STEP-5
_Start HDFS and YARN services_
```
$ start-dfs.sh
$ start-yarn.sh
$ yarn-daemons.sh start historyserver
$ yarn-daemons.sh start proxyserver
```

###Utilities:
- $HADOOP_HOME/bin/hadoop  :>>>   For basic hadoop operations
- $HADOOP_HOME/bin/yarn   :>>>   For YARN related operations
- $HADOOP_HOME/bin/mapred :>>>   For MapReduce realted operations
- $HADOOP_HOME/bin/hdfs  :>>>    For HDFS related operations

###Demoen Utilities:
- $HADOOP_HOME/sbin/start-yarn.sh;stop-yarn.sh
- $HADOOP_HOME/sbin/start-dfs.sh;stop-dfs.sh 
- $HADOOP_HOME/sbin/start-all.sh;stop-all.sh    
- $HADOOP_HOME/sbin/yarn-daemons.sh start historyserver/proxyserver


###STEP-6
Check installation using `jps`
```
$ jps
20803 NameNode
22056 JobHistoryServer
22124 WebAppProxyServer
21817 NodeManager
21560 ResourceManager
21373 SecondaryNameNode
21049 DataNode
28730 Jps

```

If these services are not up, check the logs in `$HADOOP_HOME/logs` directory to identify the issue.

###Web interfaces
- NameNode:>         http://localhost:9870
- ResourceManager:>  http://localhost:8088
- JobHistoryServer:> http://localhost:19888

###Building Hadoop Native Library

If you see  
```
WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
```
Then you have to re-compile hadoop native code manually and then put libhadoop-*.so in classpath

Prerequistes:
- $ sudo apt-get install build-essential
- $ sudo apt-get install g++ autoconf automake 

And make sure that cmake is installed correctly.

```
$ cd $HADOOP_HOME/src
$ mvn package -Pdist,native -Dskiptests -Dtar
$ cp $HADOOP_HOME/src/hadoop-dist/target/hadoop-3.2.2/lib/native/*  $HADOOP_HOME/lib/native/
```

###Setting up LZO compression
Install liblzo
- On Redhat based systems
`sudo yum install liblzo-devel`
- On Debian based systems
`sudo apt-get install liblzo2-dev`

Clone the hadoop-lzo from github
```
$ git clone https://github.com/twitter/hadoop-lzo.git
$ cd hadoop-lzo
$ mvn clean package
```

Place the hadoop-lzo-*.jar somewhere on your cluste classpath
```
$ cp hadoop-lzo/target/hadoop-lzo-0.4.20-SNAPSHOT.jar $HADOOP_HOME/share/common/ 
```

Place the native hadoop-lzo binaries in hadoop native directory
```
$ cp hadoop-lzo/target/native/Linux-amd64-64/lib/* $HADOOP_HOME/lib/native/hadoop-lzo/
```

Add the following to your `core-site.xml`:
```
<property>
<name>io.compression.codecs</name>
<value>
	org.apache.hadoop.io.compress.GzipCodec,
	org.apache.hadoop.io.compress.DefaultCodec,
	org.apache.hadoop.io.compress.BZip2Codec,
	com.hadoop.compression.lzo.LzoCodec,
	com.hadoop.compression.lzo.LzopCodec
</value>
</property>
<property>
	<name>io.compression.codec.lzo.class</name>
	<value>com.hadoop.compression.lzo.LzoCodec</value>
</property>
```

Add the following to your `mapred-site.xml`:
```
<property>
  <name>mapred.child.env</name>
  <value>JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native/hadoop-lzo/</value>
</property>
<property>
  <name>mapred.map.output.compression.codec</name>
  <value>com.hadoop.compression.lzo.LzoCodec</value>
</property>
```

###References:
- https://hadoop.apache.org

####What is on what
```
Master Node:
 - NameNode
 - ResousrceManager
 - JobHistoryServer
 - SecondaryNameNode
 
Slave Node:
 - NodeManager
 - DataNode
 - WebAppProxyServer
```

You are done! :)
