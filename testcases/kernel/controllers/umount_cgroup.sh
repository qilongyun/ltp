#!/bin/sh
umount /sys/fs/cgroup/cpuset  
umount /sys/fs/cgroup/cpu,cpuacct  
umount /sys/fs/cgroup/memory  
umount /sys/fs/cgroup/devices  
umount /sys/fs/cgroup/freezer  
umount /sys/fs/cgroup/net_cls  
umount /sys/fs/cgroup/blkio  
umount /sys/fs/cgroup/perf_event  
umount /sys/fs/cgroup/hugetlb  


