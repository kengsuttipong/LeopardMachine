<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', 'Keng1357910', "LeopardMachine");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$UserType = $_GET['UserType'];
		$FirstName = $_GET['FirstName'];
		$LastName = $_GET['LastName'];
		$UserName = $_GET['UserName'];
		$Password = $_GET['Password'];		
							
		$sql = "INSERT INTO `tbuser`(`userid`, `UserType`, `FirstName`, `LastName`, `UserName`, `Password`) VALUES (Null, '$UserType','$FirstName','$LastName','$UserName','$Password')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Leopard Machine";
   
}
	mysqli_close($link);
?>