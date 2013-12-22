#!/bin/sh

prg=$0
if [ ! -e "$prg" ]; then
  case $prg in
    (*/*) exit 1;;
    (*) prg=$(command -v -- "$prg") || exit;;
  esac
fi
dir=$(
  cd -P -- "$(dirname -- "$prg")" && pwd -P
) || exit
prg=$dir/$(basename -- "$prg") || exit 

realbin_path=`readlink $prg`
dir_real=`dirname $realbin_path`

if ! type "wp" > /dev/null 2>&1; then
  echo "wp-cli is required!"
  echo "Use 'curl https://raw.github.com/wp-cli/wp-cli.github.com/master/installer.sh | bash' to install it."
  exit
fi

dir_resolve()
{
cd "$1" 2>/dev/null || return $?  # cd to desired directory; if fail, quell any error messages but return exit status
echo "`pwd -P`" # output full, link-resolved path
}

if [ -d "`dir_resolve \"$1\"`" ] ; then
  echo "Directory exist do you want to replace it or update? replace/update/cancel [replace]"
  read shouldReplace
    if [ "$shouldReplace" = "" ] || [ "$shouldReplace" = "replace" ]; then
      shouldReplace="yes"
      rm -rf $1
      mkdir $1
    elif [ "$shouldReplace" = "update" ]; then
     install_path="`dir_resolve \"$1\"`"
     cd $1
    else
      exit 0
    fi
else 
  if [ -z "$1" ]; then
    echo "Try 'sh wpinstall.sh <Path/to/your/wordpress/folder>'"
    exit
  else
    mkdir $1
  fi
fi 

if [ "$shouldReplace" = "yes" ]; then
  install_path="`dir_resolve \"$1\"`"
  echo "================================"
  echo "    Downloading Wordpress"
  echo "================================"
  echo "Installing to $install_path"
  #wp core download
  git clone git@repo.soixantecircuits.fr:wordpress/wordpressappfog.git "$install_path"
  cd $1
else
  echo "================================"
  echo "    Updating Wordpress intall"
  echo "================================"
  echo "update/resume from $install_path"  
fi

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

wp core config --dbname=$dbname --dbuser="$dbuser" --dbpass="$dbpass" --dbhost="$dbhost" --dbprefix="$dbprefix" > 'log.txt' 2>&1

echo "================================"
echo "    Creating Database"
echo "================================"

RES=`wp db create > /dev/null 2>&1`
echo "$RES" > log.txt

if [[ $RES == *"Success"* ]]; then
  echo "... Ok"
elif [[ $RES == *"1007"* ]]; then
  echo "... Database already exist... continuing"
else
  echo "An error occured please take a look at the log output."
  exit
fi

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

cd - > /dev/null 2>&1
php=`which php`
wp_config_file="$install_path/wp-config.php"
#echo "$dir_real/changeConfig.php"
php "$dir_real/changeConfig.php" "$wp_config_file"