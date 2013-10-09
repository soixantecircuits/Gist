<?php

require($argv[1]);

$file = $argv[1];

$new_file_content.="<?php

\$services = getenv(\"VCAP_SERVICES\");
if(\$services != \"\"){
  \$services_json = json_decode(\$services,true);
  \$mysql_config = \$services_json[\"mysql-5.1\"][0][\"credentials\"];
 
  // ** MySQL settings from resource descriptor ** //
  define('DB_NAME', \$mysql_config[\"name\"]);
  define('DB_USER',\$mysql_config[\"user\"]);
  define('DB_PASSWORD', \$mysql_config[\"password\"]);
  define('DB_HOST', \$mysql_config[\"hostname\"]);
  define('DB_PORT', \$mysql_config[\"port\"]);  
} else {
  define('DB_NAME', '".constant('DB_NAME')."');
  define('DB_USER', '".constant('DB_USER')."');
  define('DB_PASSWORD', '".constant('DB_PASSWORD')."');
  define('DB_HOST', '".constant('DB_HOST')."');
  define('DB_CHARSET', 'utf8');
  define('DB_COLLATE', '');
}

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define ('WPLANG', '');
define('WP_DEBUG', false);

define('AUTH_KEY', '".constant('AUTH_KEY')."');
define('SECURE_AUTH_KEY', '".constant('SECURE_AUTH_KEY')."');
define('LOGGED_IN_KEY', '".constant('LOGGED_IN_KEY')."');
define('NONCE_KEY', '".constant('NONCE_KEY')."');
define('AUTH_SALT', '".constant('AUTH_SALT')."');
define('SECURE_AUTH_SALT', '".constant('SECURE_AUTH_SALT')."');
define('LOGGED_IN_SALT', '".constant('LOGGED_IN_SALT')."');
define('NONCE_SALT', '".constant('NONCE_SALT')."');

\$table_prefix  = '$table_prefix';

if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');";

file_put_contents($file, $new_file_content);
?>