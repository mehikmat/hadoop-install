#!/usr/bin/env python
'''
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
'''

import optparse
from pprint import pprint
import logging
import sys
import math
import ast

''' Reserved for OS + DN + NM,  Map: Memory => Reservation '''
reservedStack = { 4:1, 7:2, 8:2, 16:2, 24:4, 48:6, 64:8, 72:8, 96:12, 
                   128:24, 256:32, 512:64}
''' Reserved for HBase. Map: Memory => Reservation '''
  
reservedHBase = {4:1, 8:1, 16:2, 24:4, 48:8, 64:8, 72:8, 96:16, 
                   128:24, 256:32, 512:64}
GB = 1024

def getMinContainerSize(memory):
  if (memory <= 4):
    return 256
  elif (memory <= 8):
    return 512
  elif (memory <= 24):
    return 1024
  else:
    return 2048
  pass

def getReservedStackMemory(memory):
  if (reservedStack.has_key(memory)):
    return reservedStack[memory]
  if (memory <= 4):
    ret = 1
  elif (memory >= 512):
    ret = 64
  else:
    ret = 1
  return ret

def getReservedHBaseMem(memory):
  if (reservedHBase.has_key(memory)):
    return reservedHBase[memory]
  if (memory <= 4):
    ret = 1
  elif (memory >= 512):
    ret = 64
  else:
    ret = 2
  return ret
                    
def getRoundedMemory(memory):
  denominator = 128
  if (memory > 4096):
    denominator = 1024
  elif (memory > 2048):
    denominator = 512
  elif (memory > 1024):
    denominator = 256 
  else:
    denominator = 128

  return int(math.floor(memory/denominator)) * denominator 

def main():
  log = logging.getLogger(__name__)
  out_hdlr = logging.StreamHandler(sys.stdout)
  out_hdlr.setFormatter(logging.Formatter(' %(message)s'))
  out_hdlr.setLevel(logging.INFO)
  log.addHandler(out_hdlr)
  log.setLevel(logging.INFO)
  parser = optparse.OptionParser()
  memory = 0
  cores = 0
  disks = 0
  hbaseEnabled = True
  parser.add_option('-c', '--cores', default = 16,
                     help = 'Number of cores on each host')
  parser.add_option('-m', '--memory', default = 64, 
                    help = 'Amount of Memory on each host in GB')
  parser.add_option('-d', '--disks', default = 4, 
                    help = 'Number of disks on each host')
  parser.add_option('-k', '--hbase', default ='True',
                    help = 'True if HBase is installed, False is not')
  (options, args) = parser.parse_args()
  
  cores = int (options.cores)
  memory = int (options.memory)
  disks = int (options.disks)
  hbaseEnabled = ast.literal_eval(options.hbase)
  
  log.info("Using cores=" +  str(cores) + " memory=" + str(memory) + "GB" +
            " disks=" + str(disks) + " hbase=" + str(hbaseEnabled))
  minContainerSize = getMinContainerSize(memory)
  reservedStackMemory = getReservedStackMemory(memory)
  reservedHBaseMemory = 0
  if (hbaseEnabled):
    reservedHBaseMemory = getReservedHBaseMem(memory)
  reservedMem = reservedStackMemory + reservedHBaseMemory
  usableMem = memory - reservedMem
  memory -= (reservedMem)
  if (memory < 2):
    memory = 2 
    reservedMem = max(0, memory - reservedMem)
    
  memory *= GB
  
  containers = int (max(3, min(2 * cores,
                         min(math.ceil(1.8 * float(disks)),
                              memory/minContainerSize))))
  log.info("Profile: cores=" + str(cores) + " memory=" + str(memory) + "MB"
           + " reserved=" + str(reservedMem) + "GB" + " usableMem="
           + str(usableMem) + "GB" + " disks=" + str(disks))

  container_ram =  getRoundedMemory(abs(memory/containers))
  log.info("Num Container=" + str(containers))
  log.info("Container Ram=" + str(container_ram) + "MB")
  log.info("Used Ram=" + str(int (containers*container_ram/float(GB))) + "GB")
  log.info("Unused Ram=" + str(reservedMem) + "GB")
  

  map_memory = container_ram 
  reduce_memory = container_ram 
  if (container_ram < 2048):
    reduce_memory = 2 * container_ram
  am_memory = min(map_memory, reduce_memory)
  ''' MapReduce Configs '''
  log.info(" ")
  log.info("***** mapred-site.xml *****")
  log.info("mapreduce.map.memory.mb=" + str(int(map_memory)))
  log.info("mapreduce.map.java.opts=-Xmx" + str(getRoundedMemory(int(0.8 * map_memory))) +"m")
  log.info("mapreduce.reduce.memory.mb=" + str(int(reduce_memory)))
  log.info("mapreduce.reduce.java.opts=-Xmx" + str(getRoundedMemory(int(0.8 * reduce_memory))) + "m")
  ''' io.sort.mb cannot be greater than 2047 '''
  log.info("mapreduce.task.io.sort.mb=" + str(getRoundedMemory(int(min(0.4 * map_memory, 2047)))))

  ''' YARN Configs '''
  log.info(" ")
  log.info("***** yarn-site.xml *****")
  log.info("yarn.scheduler.minimum-allocation-mb=" + str(container_ram))
  log.info("yarn.scheduler.maximum-allocation-mb=" + str(containers*container_ram))
  log.info("yarn.nodemanager.resource.memory-mb=" + str(containers*container_ram))
  log.info("yarn.app.mapreduce.am.resource.mb=" + str(int(am_memory)))
  log.info("yarn.app.mapreduce.am.command-opts=-Xmx" + str(getRoundedMemory(int(0.8*am_memory))) + "m")

  ''' Tez Configs '''
  log.info(" ")
  log.info("***** tez-site.xml *****")
  am_memory = max(map_memory, reduce_memory)
  log.info("tez.am.resource.memory.mb=" + str(int(am_memory)))
  log.info("tez.am.java.opts=-Xmx" + str(getRoundedMemory(int(0.8*am_memory))) + "m")
  heap_size = getRoundedMemory(int(0.8 * container_ram))

  ''' Hive Configs '''
  log.info(" ")
  log.info("***** hive-site.xml *****")
  log.info("hive.tez.container.size=" + str(int(container_ram)))
  log.info("hive.tez.java.opts=-Xmx" + str(heap_size) +"m")

  hive_noconditional_task_size = int (getRoundedMemory(int(heap_size*0.33)) * 1024 * 1024)
  log.info("hive.auto.convert.join.noconditionaltask.size=" + str(hive_noconditional_task_size / 1000 * 1000))

  pass

if __name__ == '__main__':
  try:
    main()
  except(KeyboardInterrupt, EOFError):
    print("\nAborting ... Keyboard Interrupt.")
    sys.exit(1)
