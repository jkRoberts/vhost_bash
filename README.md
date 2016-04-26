# vhost_bash
The vhost.sh file is a script that will, given the correct arguments, create Vhost conf files and then enable these or delete and disable the site.

Note this is currently only works on Linux servers using Apache, Virtual Hosts and sites-enabled.

### Installation
1. Download the script file. Place the file on your server.

2. Optional - Mod the email variable in the vhost file to an email that you deem fit.

3. Make the file executable
 `$ chmod +x /path/to/vhost.sh`
You can then run the script from the where you place it.

4. Optional - Making the file globally accessible.
`sudo cp /path/to/vhost.sh /usr/local/bin/vhost`
If you go through with this step, you will be able to use the script globally

### Usage

1. Running the script from where it lives `$ ./vhost.sh create|delete|help domain_name web_path`

2. Running this script globally. `vhost create|delete|help domain_name web_path`

### Examples

These examples will assume global setup

#### Create

`sudo vhost create testwebsite.com testwebsitepath`

This will create a VirtualHost file in sites-available

`<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/testwebsitepath/public_html
    ServerName testwebsite.com
    ServerAlias www.testwebsite.com
    LogLevel error
    ErrorLog ${APACHE_LOG_DIR}/testwebsite.com-error.log
    CustomLog ${APACHE_LOG_DIR}/testwebsite.com-access.log combined
</VirtualHost>`

and then enable it.

If the site already exists, then it will return a message to say this is the case and you won't get a duplicate.

#### Delete

`sudo vhost delete testwebsite.com`

This will disable the current vhost file in sites available, restart apache and then remove the conf file.

If it doesn't find a site, then it will return a nice message to say it has not found anything.

#### Help

`sudo vhost delete testwebsite.com`

This will disable the current vhost file in sites available, restart apache and then remove the conf file.

### Contribution

If you want to contribute, then feel free to. I'm not sure how much else is needed, but feel free.
