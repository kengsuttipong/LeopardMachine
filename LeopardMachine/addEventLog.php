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
			
		$MachineID = $_GET['MachineID'];
		$UserID = $_GET['UserID'];
		$ActionDate = $_GET['ActionDate'];
		$ActionType = $_GET['ActionType'];
		$Comment = $_GET['Comment'];
		$ImageUrl = $_GET['ImageUrl'];
		$MachineCode = $_GET['MachineCode'];
		$MachineName = $_GET['MachineName'];
		$AppointmentDate = $_GET['AppointmentDate'];	
		$CauseDetail = $_GET['CauseDetail'];
		$CauseImageUrl = $_GET['CauseImageUrl'];		
		$FixedDetail = $_GET['FixedDetail'];
		$FixedImageUrl = $_GET['FixedImageUrl'];
		$IssueDetail = $_GET['IssueDetail'];
		$IssueImageUrl = $_GET['IssueImageUrl'];
		$solveListDetail = $_GET['solveListDetail'];
		$solveListImageUrl = $_GET['solveListImageUrl'];
							
		$sql = "INSERT INTO `tbeventlog`(`EventLogID`, `MachineID`, `UserID`, `ActionDate`, `ActionType`, `Comment`, `ImageUrl`, `MachineCode`, `MachineName`, `MaintenanceDate`,`CauseDetail`, `CauseImageUrl`, `FixedDetail`, `FixedImageUrl`, `IssueDetail`, `IssueImageUrl`, `solveListDetail`, `solveListImageUrl`) VALUES (Null, '$MachineID', '$UserID', '$ActionDate', '$ActionType', '$Comment', '$ImageUrl', '$MachineCode', '$MachineName', '$AppointmentDate', '$CauseDetail', '$CauseImageUrl', '$FixedDetail', '$FixedImageUrl', '$IssueDetail', '$IssueImageUrl', '$solveListDetail', '$solveListImageUrl')";

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