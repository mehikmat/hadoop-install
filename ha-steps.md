1) St host name for each machines

```
echo master1 > /etc/hostname
...
```
2) Ad all the machines to /etc/hosts file on each machines
```
# Hadoop cluster 
x.x.x.x master1
x.x.x.x master2
x.x.x.x worker1
x.x.x.x worker2
```
3) Install Java in all machines

4) Add known hosts foreach masters to workers
```
for each masters
   do ssh-keyscan -f workers.txt >> ~/.ssh/know_hosts
   
for each workers
   do ssh-keyscan -f masters.txt >> ~/.ssh/known_hosts
   
5) Install hadoop in all the machines

6) Install zookeepr in all the machines(optional)

7) Install Hbase in all the machines(optional)
   
8) Stup password less ssh from masters to workers

8) For HA: https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html
