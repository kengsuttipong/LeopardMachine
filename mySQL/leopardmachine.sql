-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 04, 2020 at 04:40 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `leopardmachine`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbmachine`
--

CREATE TABLE `tbmachine` (
  `MachineID` int(11) NOT NULL,
  `MachineName` text COLLATE utf8_unicode_ci NOT NULL,
  `AppointmentDate` date NOT NULL,
  `ImageUrl` text COLLATE utf8_unicode_ci NOT NULL,
  `MachineCode` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tbmachine`
--

INSERT INTO `tbmachine` (`MachineID`, `MachineName`, `AppointmentDate`, `ImageUrl`, `MachineCode`) VALUES
(61, 'Test MC001', '2020-06-03', '/LeopardMachine/MachineImages/machine_MC001.jpg', 'MC001'),
(62, 'Test mc002', '2020-06-03', '/LeopardMachine/MachineImages/machine_mc002.jpg', 'mc002'),
(63, 'บรรจุ1', '2020-06-25', '/LeopardMachine/MachineImages/machine_M001.jpg', 'M001'),
(64, 'บรรจุ2', '2020-06-26', '/LeopardMachine/MachineImages/machine_M002.jpg', 'M002'),
(65, 'บรรจุ3', '2020-06-03', '/LeopardMachine/MachineImages/machine_M003.jpg', 'M003');

-- --------------------------------------------------------

--
-- Table structure for table `tbprefix`
--

CREATE TABLE `tbprefix` (
  `prefixid` int(11) NOT NULL,
  `FrefixName` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tbprefix`
--

INSERT INTO `tbprefix` (`prefixid`, `FrefixName`) VALUES
(1, 'นาย'),
(2, 'นาง'),
(3, 'นางสาว');

-- --------------------------------------------------------

--
-- Table structure for table `tbuser`
--

CREATE TABLE `tbuser` (
  `userid` int(11) NOT NULL,
  `UserType` text COLLATE utf8_unicode_ci NOT NULL,
  `PrefixID` int(11) NOT NULL,
  `FirstName` text COLLATE utf8_unicode_ci NOT NULL,
  `LastName` text COLLATE utf8_unicode_ci NOT NULL,
  `UserName` text COLLATE utf8_unicode_ci NOT NULL,
  `Password` text COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `tbuser`
--

INSERT INTO `tbuser` (`userid`, `UserType`, `PrefixID`, `FirstName`, `LastName`, `UserName`, `Password`) VALUES
(1, 'user_pharmacist', 3, 'กนกอร', 'พันธ์ลำ', 'TaiRx', '1234'),
(7, 'user_pharmacist', 0, 'สุทธิพงษ์', 'ตันเมืองมา', 'Keng', '1234'),
(10, 'user_pharmacist', 0, 'กนก', 'อร', 'tai', '1234'),
(11, 'user_mechanic', 0, 'กรก', 'นะ', 'keng2', '12345'),
(12, 'user_staff', 0, 'ตัน', 'เมือง', 'test1', '1234'),
(13, 'user_staff', 0, 'ต่าย', 'จิบิ', 'jibi', '1234');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbmachine`
--
ALTER TABLE `tbmachine`
  ADD PRIMARY KEY (`MachineID`);

--
-- Indexes for table `tbprefix`
--
ALTER TABLE `tbprefix`
  ADD PRIMARY KEY (`prefixid`);

--
-- Indexes for table `tbuser`
--
ALTER TABLE `tbuser`
  ADD PRIMARY KEY (`userid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbmachine`
--
ALTER TABLE `tbmachine`
  MODIFY `MachineID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `tbprefix`
--
ALTER TABLE `tbprefix`
  MODIFY `prefixid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbuser`
--
ALTER TABLE `tbuser`
  MODIFY `userid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
