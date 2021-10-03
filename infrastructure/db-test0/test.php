<?php
echo "DB connection test\n";

$db_host = "dd";
$db_name = "";
$db_user = "dbadmin";
$db_pass = "";

echo "another day";
if( !( $db = mysqli_init() )) die('mysqli_init failed');
if( !( $db->options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, false) )) die('Setting options failed');
$db->ssl_set(NULL, NULL, "/etc/ssl/certs/ca-certificates.crt", NULL, NULL);
if( !( $db->real_connect($db_host, $db_user, $db_pass) ))
	die('Connect Error (' . mysqli_connect_errno() . ') '. mysqli_connect_error());



//, $db_name);

echo 'Success... ' . $db->host_info . "\n";

$result = $db->query("SELECT 1;");
echo print_r($result->fetch_all(MYSQLI_ASSOC),true)."\n";


$db->close();
echo "end test\n";
?>
