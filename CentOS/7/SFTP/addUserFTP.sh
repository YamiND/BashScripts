if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user or run with sudo" 2>&1
  exit 1
fi


#Backup SSHD File in case of errors

cp /etc/ssh/sshd_config ~/
chrootDir="/sftp"
sshConfig="/etc/ssh/sshd_config"

genpasswd() 
{
    < /dev/urandom LC_CTYPE=C tr -dc _A-Z-a-z-0-9 | head -c8
}

addUser()
{
	echo -e "	
Match User $username 
        ChrootDirectory /sftp/%u
        ForceCommand internal-sftp 
        X11Forwarding no 
        AllowTcpForwarding no 
        " >> $sshConfig
	systemctl restart sshd

        randomPass=$(genpasswd 8) 
	useradd $username
	echo "$username:$randomPass" | chpasswd
	
	mkdir -p $chrootDir/$username/share
	chmod 755 $chrootDir/$username 

	chown $username:sftpusers $chrootDir/$username/share
	chmod 775 $chrootDir/$username/share

	usermod -aG sftpusers -d $chrootDir/$username/share -s /sbin/nologin $username
	rm -rf /home/$username
}


	read -p "What would you like to call the username? " username
	addUser
	echo "The username is $username and the password is $randomPass"
	

