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
		$ApplyDate = $_GET['ApplyDate'];
		$IssueDetail = $_GET['IssueDetail'];
		$IssueImageUrl = $_GET['IssueImageUrl'];
		$SolveListDetail = $_GET['SolveListDetail'];			
		$SolveListImageUrl = $_GET['SolveListImageUrl'];
		$NextStatus = $_GET['NextStatus'];

		$sql = "UPDATE `tbmachine` 
				SET `MaintenanceStatus`= '$NextStatus' ,`IssueDetail` = '$IssueDetail', `IssueImageUrl` = '$IssueImageUrl', `SolveListDetail` = '$SolveListDetail', `SolveListImageUrl` = '$SolveListImageUrl' 
				WHERE MachineID = '$MachineID'";

	    $result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Leopard machine";
   
}

	mysqli_close($link);
?>