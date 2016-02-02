if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user or run with sudo" 2>&1
  exit 1
fi


#Backup SSHD File in case of errors

cp /etc/ssh/sshd_config ~/
chrootDir="/sftp"


genpasswd() 
{
    < /dev/urandom LC_CTYPE=C tr -dc _A-Z-a-z-0-9 | head -c8
}

addUser()
{
        randomPass=$(genpasswd 8) 
	useradd $username
	echo "$username:randomPass" | chpasswd
	
	mkdir -p $chrootDir/$username/incoming
	chown $username:sftpusers $chrootDir/$username/incoming

	usermod -g sftpusers -d /incoming -s /sbin/nologin $username
}


	read -p "What would you like to call the username? " username
	addUser
	echo "The username is $username and the password is $randomPass"
	

