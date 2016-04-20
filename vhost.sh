#! /bin/bash
action=$1
domain=$2
folder=$3
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
userDir='/var/www/'
sitesAvailabledomain=$sitesAvailable$domain.conf
email='webmaster@localhost'

echo -e "\n\n"

if [ "$action" != "create" ] && [ "$action" != "delete" ]
    then
        echo "You need to add an action. You can use 'create' or 'delete'"
        exit 1;
fi

while [ "$domain" == "" ]
do
    echo "Please input a domain"
    read domain
done

rootDir=$userDir$folder

if [ "$action" == 'create' ]
    then
        if [ -e $sitesAvailabledomain ]; then
             echo -e "$domain already exists"
             exit 1;
        fi

        if ! [ -d $rootDir ]; then
            mkdir $rootDir

            cd $rootDir

            mkdir public_html

            chmod 755 $rootDir
            if ! echo "<?php echo phpinfo(); ?>" > $rootDir/phpinfo.php
			then
				echo $"ERROR: Not able to write in file $rootDir/phpinfo.php. Please check permissions"
				exit;
			else
				echo $"Added content to $rootDir/phpinfo.php"
			fi
        fi

        echo "Creating $domain.conf and saving vhost content into it"

        if ! echo "<VirtualHost *:80>
            ServerAdmin $email
            DocumentRoot $rootDir/public_html
            ServerName $domain
            ServerAlias www.$domain

            LogLevel error
            ErrorLog ${APACHE_LOG_DIR}/$domain-error.log
            CustomLog ${APACHE_LOG_DIR}/$domain-access.log combined
    </VirtualHost>" > $domain.txt
        then
			echo -e $"There is an ERROR creating $domain file"
			exit;
		else
			echo -e $"\nNew Virtual Host Created\n"
		fi

		a2ensite $domain

		/etc/init.d/apache2 reload

		### show the finished message
		echo -e $"Complete! \nYou now have a new Virtual Host \nYour new host is: http://$domain \nAnd its located at $rootDir"
		exit;
    else
        if ! [ -e $sitesAvailabledomain ]; then
			echo -e $"This domain does not exist.\nPlease try another one"
			exit;
		else
            a2dissite $domain

            /etc/init.d/apache2 reload

            rm $sitesAvailabledomain
        fi

		echo -e $"Complete!\nYou just removed Virtual Host $domain"
		exit 0;
fi
