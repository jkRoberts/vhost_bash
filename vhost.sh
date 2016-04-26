#! /bin/bash
action=$1
domain=$2
folder=$3
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
userDir='/var/www/'
sitesAvailabledomain=$sitesAvailable$domain.conf
publichtml=$userDir$folder"/public_html"
email='webmaster@localhost'

echo -e "\n\n"

if [ "$action" != "create" ] && [ "$action" != "delete" ] && [ "$action" != "help" ]
    then
        echo "You need to add an action. You can use 'create' or 'delete'"
        exit 1;
fi

while [ "$domain" == "" ] && [ "$action" != "help" ]
do
    echo "Please input a domain"
    read domain
done

rootDir=$userDir$folder

if [ "$action" == 'create' ];
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
    </VirtualHost>" > $sitesAvailable$domain.conf
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
    elif [ "$action" == "delete" ]
        then
            if ! [ -e $sitesAvailabledomain ]; then
    			echo -e $"This domain does not exist.\nPlease try another one"
    			exit;
    		else
                a2dissite $domain

                /etc/init.d/apache2 reload

                rm $rootDir

                rm $sitesAvailabledomain
            fi

		echo -e $"Complete!\nYou just removed Virtual Host $domain"
		exit 0;
    else
        echo -e "The actions that you can use are:"
        echo -e "======================================="
        echo -e "=                                     ="
        echo -e "=                                     ="
        echo -e "= 'create'                            ="
        echo -e "=                                     ="
        echo -e "= This will take the arguments of     ="
        echo -e "= *youdomainname.com* *yourdirname*   ="
        echo -e "= and this will create the root dir   ="
        echo -e "= and the Vhost.conf file, enable it  ="
        echo -e "= and then restart apache, so your    ="
        echo -e "= dir is ready to go                  ="
        echo -e "=                                     ="
        echo -e "= -------------------------------------"
        echo -e "=                                     ="
        echo -e "= 'delete'                            ="
        echo -e "=                                     ="
        echo -e "= This will take the arguments of     ="
        echo -e "= *youdomainname.com*                 ="
        echo -e "= and this will delete the vhost.conf ="
        echo -e "= and then remove the root dir        ="
        echo -e "= and then restart apache             ="
        echo -e "=                                     ="
        echo -e "=                                     ="
        echo -e "======================================="
        exit 0;
fi
