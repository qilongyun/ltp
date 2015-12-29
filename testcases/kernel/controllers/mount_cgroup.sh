#!/bin/sh
mount -t cgroup -o cpuset cgroup /sys/fs/cgroup/cpuset
mount -t cgroup -o cpuacct,cpu cgroup /sys/fs/cgroup/cpu,cpuacct 
mount -t cgroup -o memory cgroup /sys/fs/cgroup/memory 
mount -t cgroup -o devices cgroup /sys/fs/cgroup/devices 
mount -t cgroup -o freezer cgroup /sys/fs/cgroup/freezer  
mount -t cgroup -o net_cls cgroup /sys/fs/cgroup/net_cls  
mount -t cgroup -o blkio cgroup /sys/fs/cgroup/blkio
mount -t cgroup -o perf_event cgroup /sys/fs/cgroup/perf_event
mount -t cgroup -o hugetlb cgroup /sys/fs/cgroup/hugetlb

