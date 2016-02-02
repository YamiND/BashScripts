if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user or run with sudo" 2>&1
  exit 1
fi


#Backup SSHD File in case of errors

cp /etc/ssh/sshd_config ~/


genpasswd() 
{
    < /dev/urandom LC_CTYPE=C tr -dc _A-Z-a-z-0-9 | head -c8
}

addUser()
{
        randomPass=$(genpasswd 8) 
	useradd -m $user
	echo "$user:$randomPass" | chpasswd
}

checkFTP()
{
	sshConfig=/etc/ssh/sshd_config
	oldSFTP="/usr/libexec/openssh/sftp-server"
	newSFTP="internal-sftp"

	if [ grep -q "$oldSFTP" "$sshConfig" ]  
	then

		sed -i "s/$oldSFTP/$newSFTP/g" "$sshConfig"
	
	elif [ grep -q "$newSFTP" "$sshConfig" ] 
	then

		echo "SFTP Line already in $sshConfig"

	else
	
		echo "Subsystem sftp internal-sftp" >> $sshConfig

	fi

	cat << EOF >> /etc/ssh/sshd_config

        	Match Group sftpusers
        	ChrootDirectory %h
        	ForceCommand internal-sftp
        	X11Forwarding no
        	AllowTcpForwarding no

        EOF
}


#	read -p "What would you like to call the username? " username
#	addUser
#	echo $randomPass

	
	checkFTP

