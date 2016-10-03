#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user or run with sudo" 2>&1
  exit 1
fi

checkFTP()
{
        sshConfig=/etc/ssh/sshd_config
        oldSFTP="/usr/libexec/openssh/sftp-server"
        newSFTP="internal-sftp"

        if grep -q "$oldSFTP" "$sshConfig"
        then
                sed -i "s|$oldSFTP|$newSFTP|g" "$sshConfig"
        elif grep -q "$newSFTP" "$sshConfig"
        then
                echo "SFTP Line already in $sshConfig"
        else
                echo "Subsystem sftp internal-sftp" >> $sshConfig
        fi

        if grep -q "sftpusers" "$sshConfig"
        then
                echo "Entry already in $sshConfig"
        else

        fi
}

        checkFTP

	mkdir /sftp
	groupadd sftpusers
	systemctl restart sshd
