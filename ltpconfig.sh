#!/bin/sh

	yum install net-tools -y
	yum install screen  -y 
	yum install radvd   -y
#设置 env 环境变量

    #获取主机名
    RHOST=${RHOST:-$(hostname)}
	
    #获取网卡名
	LocalIP4=$(ping -c1 $(hostname)|awk '{print $3}'|sed -n 1p |sed 's/(//g'|sed 's/)//g')
	netdev_name=$(ifconfig|awk '/'$LocalIP4'/{print a}{a=$1}')
	netdev_name=${netdev_name%?}    

	needSetENV=0
	
	env|grep PASSWD || needSetENV=1
	
	tmpStr=`env|grep RHOST_IFACES` 
	if [ -z  ${tmpStr#*=} ] ; then
		needSetENV=1;
	fi;
	
	if [ $needSetENV -eq 1 ] ; then 
	cat >> /root/.bash_profile  <<-EOF
	
	export RHOST=$RHOST
	export PASSWD=123456	
	export LANG=en_US.UTF-8
	export LHOST_IFACES=$netdev_name
	export RHOST_IFACES=$netdev_name
	EOF
	
	source /root/.bash_profile
	fi
	
	
	cat /root/.bash_profile	

	yum groupinstall "development tools" -y
	yum install libaio-devel -y
	yum install libtirpc-devel -y
	yum install expect -y
	yum install flex-devel -y
	yum install libcap-devel -y
	yum install vsftpd -y
	yum install sssd-tools -y
	yum install nscd -y
	yum install mutt -y
	yum install numactl -y
	yum install numactl-devel -y
	yum install mkisofs -y
	yum install psmisc  -y
	yum install quota   -y
	yum install tcsh    -y

	
	#安装网络相关包
	yum install tcpdump -y
	yum install bind-utils -y
	yum install traceroute -y
	yum install nfs-utils -y
	yum install xinetd -y
	yum install rsh -y
	yum install rsh-server -y
    yum install rusers -y
	yum install rusers-server -y
	yum install telnet -y
	yum install telnet-server -y
	yum install finger finger-server -y
	yum install ftp vsftpd -y
	yum install rdist -y
	yum install rwho -y
	yum install dhcp -y

	
	cat > /etc/xinetd.d/rsh  <<-EOF
	
	service shell 
	{ 
		disable = no 
		socket_type = stream 
		wait = no 
		user = root 
		log_on_success += USERID 
		log_on_failure += USERID 
		server = /usr/sbin/in.rshd 
	}
	
	EOF
	
	cat > /etc/xinetd.d/rlogin  <<-EOF
	
	service login 
	{ 
		 disable = no 
		 socket_type = stream 
		 wait = no 
		 user = root 
		 passwd = 123456
		 log_on_success += USERID 
		 log_on_failure += USERID 
		 server = /usr/sbin/in.rlogind 
	 }  
	
	EOF
	
	cat > /etc/xinetd.d/telnet  <<-EOF
	
	service telnet
   {
		disable = yes
		flags = REUSE
		socket_type = stream
		wait = no
		user = root
		server = /usr/sbin/in.telnetd
		log_on_failure += USERID
	}

	EOF
	
	cat > /etc/xinetd.d/finger  <<-EOF	
	service finger
	{
		disable = no
		socket_type = stream
		wait = no
		user = root
		server = /usr/sbin/in.fingerd
		log_on_failure += USERID
	}
	EOF
	
	
	
	cat > /etc/xinetd.d/echo-stream  <<-EOF
	service echo
   {
        disable = no
        id              = echo-stream
        type            = INTERNAL
        wait            = no
        socket_type     = stream
   }
	EOF
	
	cat >> /etc/securetty  <<-EOF	
rsh
rlogin
rexec
pts/0
pts/1
pts/2
pts/3
pts/4
pts/5
pts/6
pts/7
pts/8
pts/9
pts/10
pts/11
pts/12
	EOF
	
	cat > /root/.rhosts  <<-EOF
$RHOST root
	EOF
	
	cat > /etc/exports  <<-EOF
	/ 192.168.1.0/24(rw,sync,no_root_squash)
	EOF
	
	
	cat > /etc/radvd.conf  <<-EOF
	interface eth0
{
        AdvSendAdvert on;
        MinRtrAdvInterval 30;
        MaxRtrAdvInterval 100;
        prefix fd00:1:1:1::/64
        {
                AdvOnLink on;
                AdvAutonomous on;
                AdvRouterAddr off;
        };

};
	EOF
	
	
	sed -i 's/root/#root/g' /etc/vsftpd/ftpusers
	sed -i 's/root/#root/g' /etc/vsftpd/user_list
		
	
	
	# 关闭防火墙	
	systemctl stop firewalld
	systemctl mask firewalld	
	systemctl stop iptables
	systemctl mask iptables
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0
	
	#启动服务
	systemctl stop rpcbind.target
    systemctl stop rpcbind.socket
    systemctl stop rpcbind.service
	systemctl stop rpcbind.service
	systemctl stop nfs-mountd.service
	systemctl start rpcbind.service
	systemctl start nfs-mountd.service
	
	systemctl restart rstatd
	systemctl restart telnet.socket
	systemctl restart xinetd.service
	systemctl restart vsftpd.service
	systemctl restart radvd
	
    
	
	
	
	echo "=============================================="
	echo "please manual add host an ip into /etc/hosts"
    echo "=============================================="
	
	cat /etc/hosts
	
	echo "=============================================="
	echo "please use  \"exit\" relogin the test machine"
    echo "=============================================="

    