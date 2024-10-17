-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 18, 2024 at 01:12 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `golang_project`
--

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `team_id` int(11) NOT NULL,
  `team_name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`team_id`, `team_name`, `created_at`) VALUES
(1, 'Development A', '2024-10-17 20:07:07'),
(2, 'Development B', '2024-10-17 21:41:13'),
(3, 'Development C', '2024-10-17 22:43:18');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) NOT NULL,
  `username` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `team_id` int(11) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `firstname`, `lastname`, `email`, `phone`, `role`, `created_at`, `team_id`, `password`) VALUES
(1, 'sanhanatadmin', 'sanhanat', 'sukkoram', 'sanhanatohm@gmail.com', '0927490982', 'Frontend Developer', '2024-10-17 20:09:40.558474', 1, '$2a$10$c4lTiSJHAigjbL72ZY2iJOTlVTohVEFv/LL3rfQQhj7YcHqzJ8J1y'),
(2, 'sanhanatadmin2', 'sanhanat2', 'sukkoram2', 'sanhanatohm2@gmail.com', '0123456789', 'Mobile Developer', '2024-10-17 21:47:43.065890', 2, '$2a$10$DU0Y5aYxTiwkysQzm9DIeO0K3pEEPo8cBzMobgO3wW1KPQhjl9cl2'),
(3, 'john_doe', 'John', 'Doe', 'john.doe@example.com', '0891234567', 'Sale', '2024-10-17 22:43:35.177578', 3, '$2a$10$weS0a3cDqPqS1Vk8xTeEDeP7.15NG8hxxRx5nwxtTEt.9d6u6rRhy'),
(4, 'jdoe', 'John', 'Doe', 'jdoe@example.com', '0812345678', 'Frontend Developer', '2024-10-17 23:05:29.265981', 2, '$2a$10$sQzJSDE4LbPaob9BHFu9AeygF.pOJlpr0zYi3kCNCLU3Uh/zG6cjy'),
(5, 'asmith', 'Alice', 'Smith', 'asmith@example.com', '0898765432', 'Backend Developer', '2024-10-17 23:05:35.639342', 3, '$2a$10$iouXzAk6CbWYgvWtltjT0OT8ixgN8EdG3K8TqZ2.kMaltGVtdK9xO'),
(6, 'bwhite', 'Bob', 'White', 'bwhite@example.com', '0823456789', 'Fullstack Engineer', '2024-10-17 23:09:30.127952', 1, '$2a$10$E5MX65EoaUIvfaNPLnSmiuDaHCQhbOmebLgf09CP1PMc9vGBxYlwS'),
(7, 'jking', 'James', 'King', 'jking@example.com', '0834567890', 'Mobile App Developer', '2024-10-17 23:10:22.227799', 1, '$2a$10$w5oCgPzOoZWVMNyNVGHMEuyJyMc5uJ5p.57CovDQ166TIXdpSzUNm'),
(8, 'lgreen', 'Laura', 'Green', 'lgreen@example.com', '0845678901', 'UI/UX Designer', '2024-10-17 23:10:30.046404', 2, '$2a$10$s9qfHS1Onqz/EJcH7U6O3OLq0c1vnXBWHv20eyRFJuFBWGPmu/hpe'),
(9, 'tjohnson', 'Tom', 'Johnson', 'tjohnson@example.com', '0856789012', 'DevOps Engineer', '2024-10-17 23:10:36.169696', 2, '$2a$10$yya1S2CgRPBbFxh3SODlH.Gp9JVF.ofWXP686bUiwIvycUVHRbqj.'),
(10, 'kparker', 'Kate', 'Parker', 'kparker@example.com', '0867890123', 'QA Engineer', '2024-10-17 23:10:40.191606', 3, '$2a$10$ArJqsrJ/ydp9c.0OkQk2/.kjN.VcH1AL0qVAvK44m67SR82N9J.ly'),
(11, 'dlewis', 'David', 'Lewis', 'dlewis@example.com', '0878901234', 'Software Architect', '2024-10-17 23:10:46.131313', 1, '$2a$10$e0gwmzcq5Gkx4snTkWRE2uMOW2WaWJA.DX96yvg0WhPHrjeUS8zJq'),
(12, 'nmartin', 'Nina', 'Martin', 'nmartin@example.com', '0889012345', 'Product Manager', '2024-10-17 23:10:50.241601', 3, '$2a$10$QvE7AX6vLnT6V/0eKDwSr.4uoGd79R5ikAWdnVG2R9ipC5RG4jqq.'),
(13, 'mmiller', 'Mark', 'Miller', 'mmiller@example.com', '0890123456', 'Data Scientist', '2024-10-17 23:11:04.271779', 1, '$2a$10$RmmKgSa4Ui2QKoEo98446ezZ7qSyUDSdWYhDYepJLqvftbW964k8y'),
(14, 'sdoe', 'Sarah', 'Doe', 'sdoe@example.com', '0912345678', 'Frontend Developer', '2024-10-17 23:11:07.975373', 3, '$2a$10$WADVrwkeNWrW1oLJBcLAPurKuVDdogSnRHIW/M/6MLd.y1ieD/EKC'),
(15, 'rsmith', 'Robert', 'Smith', 'rsmith@example.com', '0923456789', 'Backend Developer', '2024-10-17 23:11:12.815989', 2, '$2a$10$tOM.QC4AZReQU3yjz2xfjONGEFDKSn8FiJHK8z6XvzDPEQF.D2EEm'),
(16, 'bblack', 'Bella', 'Black', 'bblack@example.com', '0934567890', 'Fullstack Engineer', '2024-10-17 23:11:19.363306', 3, '$2a$10$vMKScj4gzF5Xgh/50i1YNeTRofe4vRIjLw7fXWslzSjS8EPI0kYYu'),
(17, 'jmoore', 'Jake', 'Moore', 'jmoore@example.com', '0945678901', 'Mobile App Developer', '2024-10-17 23:11:23.350185', 3, '$2a$10$wC1EOPFdC8JNfECv7zkn7e0hlsgOSOLgqq1sML1NK8c5q2TZ1wF/2'),
(18, 'cwhite', 'Charlie', 'White', 'cwhite@example.com', '0956789012', 'UI/UX Designer', '2024-10-17 23:11:27.049312', 3, '$2a$10$sduJ3JMy3ttQ/I6hx8108ea55OatQFp0K.cQCAiXE3RbOJGplNc/S'),
(19, 'mpeters', 'Mia', 'Peters', 'mpeters@example.com', '0967890123', 'DevOps Engineer', '2024-10-17 23:11:33.148051', 1, '$2a$10$xkzgQq1UPzPrr3XnLbNBPuaDY3XGGLp9GkRq/txVKrmXkxGV8TyNm'),
(20, 'kharris', 'Kevin', 'Harris', 'kharris@example.com', '0978901234', 'QA Engineer', '2024-10-17 23:11:38.877999', 2, '$2a$10$kl6TYOalHO5C4MtDN8GFzuw9t6/HGAe4ob6pZcg.Zy.takQ2EaJte'),
(21, 'alewis', 'Alice', 'Lewis', 'alewis@example.com', '0989012345', 'Software Architect', '2024-10-17 23:11:44.948822', 3, '$2a$10$X8xaslNHuNVY00fMFludU.bJGjoW2Z6Mt3LLuwA0XkRBxIUhdL7rq'),
(22, 'bwong', 'Brian', 'Wong', 'bwong@example.com', '0990123456', 'Product Manager', '2024-10-17 23:11:48.638410', 1, '$2a$10$1wp7aCKpuHPfuixlnO6hVuUxmnl3KDGg8w1Y.RBXbJ3ysk2QZXAGC'),
(23, 'tdavis', 'Tina', 'Davis', 'tdavis@example.com', '0901234567', 'Data Scientist', '2024-10-11 23:06:50.000000', NULL, ''),
(24, 'mallen', 'Mark', 'Allen', 'mallen@example.com', '0912345678', 'Frontend Developer', '2024-06-27 23:07:46.000000', NULL, ''),
(25, 'sdavis', 'Sophia', 'Davis', 'sdavis@example.com', '0923456789', 'Backend Developer', '2024-08-17 23:07:46.000000', NULL, ''),
(26, 'jchen', 'Jason', 'Chen', 'jchen@example.com', '0934567890', 'Fullstack Engineer', '2023-11-20 23:07:46.000000', NULL, ''),
(27, 'lgarcia', 'Linda', 'Garcia', 'lgarcia@example.com', '0945678901', 'Mobile App Developer', '2024-09-29 23:07:46.000000', NULL, ''),
(28, 'jkim', 'James', 'Kim', 'jkim@example.com', '0956789012', 'UI/UX Designer', '2024-04-09 23:07:46.000000', NULL, ''),
(29, 'klee', 'Karen', 'Lee', 'klee@example.com', '0967890123', 'DevOps Engineer', '2024-05-01 23:07:46.000000', NULL, ''),
(30, 'jrobinson', 'John', 'Robinson', 'jrobinson@example.com', '0978901234', 'QA Engineer', '2024-01-18 23:07:46.000000', NULL, ''),
(31, 'fmartinez', 'Frank', 'Martinez', 'fmartinez@example.com', '0989012345', 'Software Architect', '2024-06-10 23:07:46.000000', NULL, ''),
(32, 'djohnson', 'Daniel', 'Johnson', 'djohnson@example.com', '0990123456', 'Product Manager', '2024-04-07 23:07:46.000000', NULL, ''),
(33, 'cwilliams', 'Cynthia', 'Williams', 'cwilliams@example.com', '0901234567', 'Data Scientist', '2024-03-20 23:07:46.000000', NULL, ''),
(34, 'tmoore', 'Tom', 'Moore', 'tmoore@example.com', '0912345678', 'Frontend Developer', '2024-03-26 23:08:42.000000', NULL, ''),
(35, 'bthompson', 'Bella', 'Thompson', 'bthompson@example.com', '0923456789', 'Backend Developer', '2024-04-11 23:08:42.000000', NULL, ''),
(36, 'mcarter', 'Michael', 'Carter', 'mcarter@example.com', '0934567890', 'Fullstack Engineer', '2023-11-19 23:08:42.000000', NULL, ''),
(37, 'nwilson', 'Nina', 'Wilson', 'nwilson@example.com', '0945678901', 'Mobile App Developer', '2024-10-13 23:08:42.000000', NULL, ''),
(38, 'yrodriguez', 'Yvonne', 'Rodriguez', 'yrodriguez@example.com', '0956789012', 'UI/UX Designer', '2024-06-21 23:08:42.000000', NULL, ''),
(39, 'jmartinez', 'Jacob', 'Martinez', 'jmartinez@example.com', '0967890123', 'DevOps Engineer', '2024-03-21 23:08:42.000000', NULL, ''),
(40, 'mlopez', 'Maria', 'Lopez', 'mlopez@example.com', '0978901234', 'QA Engineer', '2023-11-20 23:08:42.000000', NULL, ''),
(41, 'tjackson', 'Tina', 'Jackson', 'tjackson@example.com', '0989012345', 'Software Architect', '2023-12-20 23:08:42.000000', NULL, ''),
(42, 'csmith', 'Chris', 'Smith', 'csmith@example.com', '0990123456', 'Product Manager', '2024-05-21 23:08:42.000000', NULL, ''),
(43, 'jthomas', 'Jessica', 'Thomas', 'jthomas@example.com', '0901234567', 'Data Scientist', '2024-03-28 23:08:42.000000', NULL, ''),
(44, 'ahall', 'Alex', 'Hall', 'ahall@example.com', '0912345678', 'Frontend Developer', '2024-03-28 23:08:42.000000', NULL, ''),
(45, 'shernandez', 'Samantha', 'Hernandez', 'shernandez@example.com', '0923456789', 'Backend Developer', '2024-09-06 23:08:42.000000', NULL, ''),
(46, 'rwood', 'Ryan', 'Wood', 'rwood@example.com', '0934567890', 'Fullstack Engineer', '2023-11-25 23:08:42.000000', NULL, ''),
(47, 'gyoung', 'Grace', 'Young', 'gyoung@example.com', '0945678901', 'Mobile App Developer', '2024-08-26 23:08:42.000000', NULL, ''),
(48, 'hking', 'Henry', 'King', 'hking@example.com', '0956789012', 'UI/UX Designer', '2024-10-07 23:08:42.000000', NULL, ''),
(49, 'jclark', 'Julia', 'Clark', 'jclark@example.com', '0967890123', 'DevOps Engineer', '2024-01-31 23:08:42.000000', NULL, ''),
(50, 'bwalker', 'Brian', 'Walker', 'bwalker@example.com', '0978901234', 'QA Engineer', '2024-04-25 23:08:42.000000', NULL, ''),
(51, 'llee', 'Laura', 'Lee', 'llee@example.com', '0989012345', 'Software Architect', '2024-07-15 23:08:42.000000', NULL, ''),
(52, 'dbrown', 'David', 'Brown', 'dbrown@example.com', '0990123456', 'Product Manager', '2023-12-10 23:08:42.000000', NULL, ''),
(53, 'mmorris', 'Michelle', 'Morris', 'mmorris@example.com', '0901234567', 'Data Scientist', '2024-04-17 23:08:42.000000', NULL, ''),
(54, 'snelson', 'Steve', 'Nelson', 'snelson@example.com', '0912345678', 'Frontend Developer', '2023-11-06 23:08:42.000000', NULL, ''),
(55, 'kparker', 'Kevin', 'Parker', 'kparker@example.com', '0923456789', 'Backend Developer', '2024-07-25 23:08:42.000000', NULL, ''),
(56, 'lmitchell', 'Laura', 'Mitchell', 'lmitchell@example.com', '0934567890', 'Fullstack Engineer', '2024-06-26 23:08:42.000000', NULL, ''),
(57, 'dcole', 'Daniel', 'Cole', 'dcole@example.com', '0945678901', 'Mobile App Developer', '2023-12-10 23:08:42.000000', NULL, ''),
(58, 'pkim', 'Paul', 'Kim', 'pkim@example.com', '0956789012', 'UI/UX Designer', '2024-06-10 23:08:42.000000', NULL, ''),
(59, 'awright', 'Alice', 'Wright', 'awright@example.com', '0967890123', 'DevOps Engineer', '2024-08-06 23:08:42.000000', NULL, '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`team_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team_id` (`team_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `team_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
