<?php
	header('Content-Type: application/json');
	echo json_encode(array(
		"IPv4" => $_SERVER["REMOTE_ADDR"],
		"UserAgent" => $_SERVER["HTTP_USER_AGENT"],
		"TimeStamp" => gmdate("c")
	));
?>