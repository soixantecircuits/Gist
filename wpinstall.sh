#!/bin/sh

if [ $1 = ""];
	then
	echo "Try 'sh wpinstall.sh <Path/to/your/wordpress/folder>'"
	exit
fi

mkdir $1 #&& cd $1
if [ $? != 0 ]; 
	then 
	exit $? 
fi  


echo "================================"
echo "    Downloading Wordpress"
echo "================================"

#wp core download
git clone git@repo.soixantecircuits.fr:wordpress/wordpressappfog.git $1

cd $1

echo "================================"
echo "    Wordpress Configuration"
echo "================================"

echo "Database Name?"
read dbname

echo "Database User Name?"
read dbuser

echo "Database Password?"
read -s dbpass

echo "Database Hostname? Just press enter to use default hostname: localhost"
read dbhost

echo "Database Prefix? Just press to use default prefix: wp_"
read dbprefix


if [ "$dbhost" = "" ]; then
	dbhost="localhost"
fi
if [ "$dbprefix" = "" ]; then
	dbprefix="wp_"
fi

wp core config --dbname=$dbname --dbuser="$dbuser" --dbpass="$dbpass" --dbhost="$dbhost" --dbprefix="$dbprefix"

wp db create "$dbname"


echo "================================"
echo "    Wordpress Installation"
echo "================================"

echo "Site Url?"
read url

echo "Site Title?"
read title

echo "Admin Name?"
read admin

echo "Admin Password?"
read -s pass

echo "Admin Email?"
read email
wp core install --url="$url" --title="$title" --admin_name="$admin" --admin_password="$pass" --admin_email="$email"


echo "================================"
echo "    Updating Wordpress"
echo "================================"

wp core update

echo "================================"
echo "    Updating Plugins"
echo "================================"

wp plugin update-all

echo "================================"
echo "    Activating Plugins"
echo "================================"

wp plugin activate wpmandrill

wp plugin activate wp-migrate-db-pro


echo "============================================================================================"
echo "    Congratulations! You have now a fresh install of wordpress with some basic plugins!"
echo "============================================================================================"
