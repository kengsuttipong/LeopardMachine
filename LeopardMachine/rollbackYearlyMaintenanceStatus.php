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
					
		$MachineID = $_GET['machineid'];
		$rollbackStatus = $_GET['rollbackStatus'];
		$UpdateBy = $_GET['UpdateBy'];
		$UpdateDate = $_GET['UpdateDate'];			

		$sql = "UPDATE `tbmachine` 
				SET `MaintenanceStatus`= '$rollbackStatus'
				WHERE MachineID = '$MachineID'";

	    $result = mysqli_query($link, $sql);

	    /*$sql = "UPDATE `tbmachine` 
				SET `CauseDetail`= '', `CauseImageUrl` = '', `FixedDetail` = '', `FixedImageUrl` = ''
				WHERE MachineID = '$MachineID' and `machineMaintenanceStatus` = 'availableMachine'";

	    $result = mysqli_query($link, $sql);*/

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Leopard machine";
   
}

	mysqli_close($link);
?>