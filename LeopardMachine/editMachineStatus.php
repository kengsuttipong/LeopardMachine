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
			
		$UserID = $_GET['UserID'];
		$MachineID = $_GET['MachineID'];		
		$MaintenanceStatus = $_GET['MaintenanceStatus'];
		$ApplyDate = $_GET['ApplyDate'];	

		echo $MachineID;
		echo $MaintenanceStatus;	

		$sql = "UPDATE `tbmachine` 
		        SET `machineMaintenanceStatus` = '$MaintenanceStatus', `UpdateBy` = '$UserID', `UpdateDate` = '$ApplyDate'
		        WHERE MachineID = $MachineID";
	    echo $sql;

		$result = mysqli_query($link, $sql);
		echo $link->error;

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Keng Foods";
   
}

	mysqli_close($link);
?>