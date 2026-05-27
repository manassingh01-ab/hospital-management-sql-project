-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 27, 2026 at 09:05 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital_db`
--
CREATE DATABASE IF NOT EXISTS `hospital_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `hospital_db`;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `status` enum('Scheduled','Completed','Cancelled','No-Show') DEFAULT 'Scheduled',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `patient_id`, `doctor_id`, `appointment_date`, `appointment_time`, `reason`, `status`, `notes`, `created_at`) VALUES
(1, 2, 1, '2026-03-25', '10:00:00', 'Routine cardiac checkup', 'Scheduled', NULL, '2026-04-08 13:54:26'),
(2, 4, 2, '2026-03-25', '11:30:00', 'Recurring headaches', 'Scheduled', NULL, '2026-04-08 13:54:26'),
(3, 2, 3, '2026-03-26', '09:00:00', 'Knee pain follow-up', 'Scheduled', NULL, '2026-04-08 13:54:26'),
(4, 1, 1, '2026-03-15', '10:00:00', 'Initial consultation', 'Completed', NULL, '2026-04-08 13:54:26'),
(5, 3, 3, '2026-03-18', '09:30:00', 'Pre-surgery assessment', 'Completed', NULL, '2026-04-08 13:54:26');

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `bill_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `admission_id` int(11) DEFAULT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `bill_date` datetime DEFAULT current_timestamp(),
  `due_date` date DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(10,2) DEFAULT 0.00,
  `tax` decimal(10,2) DEFAULT 0.00,
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(12,2) DEFAULT 0.00,
  `balance` decimal(12,2) GENERATED ALWAYS AS (`total_amount` - `paid_amount`) STORED,
  `status` enum('Pending','Partial','Paid','Cancelled','Refunded') DEFAULT 'Pending',
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`bill_id`, `patient_id`, `admission_id`, `appointment_id`, `bill_date`, `due_date`, `subtotal`, `discount`, `tax`, `total_amount`, `paid_amount`, `status`, `notes`) VALUES
(1, 1, 1, NULL, '2026-03-20 00:00:00', '2026-04-20', 25000.00, 0.00, 0.00, 25000.00, 10000.00, 'Partial', NULL),
(2, 3, 2, NULL, '2026-03-21 00:00:00', '2026-04-21', 18000.00, 0.00, 0.00, 18000.00, 18000.00, 'Paid', NULL),
(3, 5, 3, NULL, '2026-03-23 00:00:00', '2026-04-23', 12000.00, 0.00, 0.00, 12000.00, 0.00, 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `bill_items`
--

CREATE TABLE `bill_items` (
  `item_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `item_type` enum('Consultation','Room','Medicine','Lab','Surgery','Procedure','Other') NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill_items`
--

INSERT INTO `bill_items` (`item_id`, `bill_id`, `description`, `item_type`, `quantity`, `unit_price`, `total_price`) VALUES
(1, 1, 'ICU Room (4 days)', 'Room', 4, 5000.00, 20000.00),
(2, 1, 'Cardiologist Consultation', 'Consultation', 1, 800.00, 800.00),
(3, 1, 'ECG & Echo', 'Procedure', 2, 2100.00, 4200.00),
(4, 2, 'Single Room (3 days)', 'Room', 3, 2200.00, 6600.00),
(5, 2, 'Orthopaedic Consultation', 'Consultation', 1, 700.00, 700.00),
(6, 2, 'Fracture Surgery', 'Surgery', 1, 10000.00, 10000.00),
(7, 3, 'Emergency Room (2 days)', 'Room', 2, 3500.00, 7000.00),
(8, 3, 'Cardiologist Consultation', 'Consultation', 1, 800.00, 800.00),
(9, 3, 'Medicines & Supplies', 'Medicine', 1, 4200.00, 4200.00);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(100) NOT NULL,
  `head_doctor_id` int(11) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `dept_name`, `head_doctor_id`, `location`, `phone`, `created_at`) VALUES
(1, 'Cardiology', NULL, 'Block A, Floor 2', '0512-300-101', '2026-04-08 13:51:21'),
(2, 'Neurology', NULL, 'Block B, Floor 1', '0512-300-102', '2026-04-08 13:51:21'),
(3, 'Orthopedics', NULL, 'Block C, Floor 3', '0512-300-103', '2026-04-08 13:51:21'),
(4, 'Pediatrics', NULL, 'Block A, Floor 1', '0512-300-104', '2026-04-08 13:51:21'),
(5, 'General Medicine', NULL, 'Block D, Floor 1', '0512-300-105', '2026-04-08 13:51:21'),
(6, 'Pharmacy', NULL, 'Ground Floor', '0512-300-200', '2026-04-08 13:51:21');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `doctor_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `specialization` varchar(100) NOT NULL,
  `qualification` varchar(200) DEFAULT NULL,
  `license_number` varchar(50) NOT NULL,
  `consultation_fee` decimal(10,2) DEFAULT 0.00,
  `available_days` set('Mon','Tue','Wed','Thu','Fri','Sat','Sun') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`doctor_id`, `staff_id`, `specialization`, `qualification`, `license_number`, `consultation_fee`, `available_days`) VALUES
(1, 1, 'Cardiology', 'MD, DM Cardiology', 'MCI-CARD-001', 800.00, 'Mon,Tue,Wed,Thu,Fri'),
(2, 2, 'Neurology', 'MD, DM Neurology', 'MCI-NEUR-002', 900.00, 'Mon,Wed,Fri'),
(3, 3, 'Orthopedics', 'MS Orthopedics', 'MCI-ORTH-003', 700.00, 'Tue,Thu,Sat'),
(4, 7, 'Pediatrics', 'MD Pediatrics, MRCP', 'MCI-PEDI-004', 600.00, 'Mon,Tue,Wed,Thu,Fri');

-- --------------------------------------------------------

--
-- Table structure for table `insurance_claims`
--

CREATE TABLE `insurance_claims` (
  `claim_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `provider_name` varchar(150) NOT NULL,
  `policy_number` varchar(100) NOT NULL,
  `claim_amount` decimal(12,2) NOT NULL,
  `approved_amount` decimal(12,2) DEFAULT NULL,
  `status` enum('Submitted','Under Review','Approved','Rejected','Paid') DEFAULT 'Submitted',
  `submitted_date` date DEFAULT NULL,
  `resolved_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicines`
--

CREATE TABLE `medicines` (
  `medicine_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `generic_name` varchar(150) DEFAULT NULL,
  `category` varchar(80) DEFAULT NULL,
  `manufacturer` varchar(120) DEFAULT NULL,
  `unit` varchar(30) DEFAULT 'Tablet',
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stock_qty` int(11) NOT NULL DEFAULT 0,
  `reorder_level` int(11) NOT NULL DEFAULT 10,
  `expiry_date` date DEFAULT NULL,
  `requires_prescription` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medicines`
--

INSERT INTO `medicines` (`medicine_id`, `name`, `generic_name`, `category`, `manufacturer`, `unit`, `unit_price`, `stock_qty`, `reorder_level`, `expiry_date`, `requires_prescription`, `created_at`) VALUES
(1, 'Aspirin 75mg', 'Aspirin', 'Antiplatelet', 'Sun Pharma', 'Tablet', 2.50, 500, 50, '2027-12-31', 1, '2026-04-08 13:54:43'),
(2, 'Atorvastatin 20mg', 'Atorvastatin', 'Statin', 'Cipla', 'Tablet', 8.00, 300, 30, '2027-06-30', 1, '2026-04-08 13:54:43'),
(3, 'Metformin 500mg', 'Metformin HCl', 'Antidiabetic', 'Dr. Reddys', 'Tablet', 3.50, 200, 25, '2026-09-30', 1, '2026-04-08 13:54:43'),
(4, 'Paracetamol 500mg', 'Paracetamol', 'Analgesic', 'GSK India', 'Tablet', 1.50, 800, 100, '2027-03-31', 1, '2026-04-08 13:54:43'),
(5, 'Amoxicillin 500mg', 'Amoxicillin', 'Antibiotic', 'Mankind Pharma', 'Capsule', 12.00, 15, 20, '2026-12-31', 1, '2026-04-08 13:54:43'),
(6, 'Normal Saline 500ml', 'Sodium Chloride', 'IV Fluid', 'Baxter', 'Bottle', 120.00, 60, 15, '2026-08-31', 1, '2026-04-08 13:54:43'),
(7, 'Omeprazole 20mg', 'Omeprazole', 'PPI', 'Torrent Pharma', 'Capsule', 5.00, 400, 40, '2027-01-31', 1, '2026-04-08 13:54:43'),
(8, 'Ceftriaxone 1g', 'Ceftriaxone', 'Antibiotic', 'Sun Pharma', 'Vial', 180.00, 8, 10, '2026-10-31', 1, '2026-04-08 13:54:43');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `patient_id` int(11) NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `dob` date NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `blood_group` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `emergency_contact_name` varchar(120) DEFAULT NULL,
  `emergency_contact_phone` varchar(20) DEFAULT NULL,
  `medical_history` text DEFAULT NULL,
  `allergies` text DEFAULT NULL,
  `registered_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`patient_id`, `first_name`, `last_name`, `dob`, `gender`, `blood_group`, `phone`, `email`, `address`, `emergency_contact_name`, `emergency_contact_phone`, `medical_history`, `allergies`, `registered_at`) VALUES
(1, 'Ramesh', 'Kumar', '1965-03-10', 'Male', 'B+', '9811111111', 'ramesh.k@email.com', 'Civil Lines, Kanpur', 'Suresh Kumar', '9811111112', NULL, NULL, '2026-04-08 13:53:19'),
(2, 'Anita', 'Patel', '1990-07-22', 'Female', 'A+', '9822222222', 'anita.p@email.com', 'Swaroop Nagar, Kanpur', 'Rajesh Patel', '9822222223', NULL, NULL, '2026-04-08 13:53:19'),
(3, 'Vikas', 'Tiwari', '1978-11-05', 'Male', 'O-', '9833333333', 'vikas.t@email.com', 'Kidwai Nagar, Kanpur', 'Meena Tiwari', '9833333334', NULL, NULL, '2026-04-08 13:53:19'),
(4, 'Shalini', 'Mishra', '2001-01-15', 'Female', 'AB+', '9844444444', 'shalini.m@email.com', 'Kakadeo, Kanpur', 'Sunil Mishra', '9844444445', NULL, NULL, '2026-04-08 13:53:19'),
(5, 'Amit', 'Srivastava', '1955-06-28', 'Male', 'A-', '9855555555', 'amit.s@email.com', 'Armapur, Kanpur', 'Rita Srivastava', '9855555556', NULL, NULL, '2026-04-08 13:53:19'),
(6, 'vimal', 'yadav', '2000-09-04', 'Male', 'B+', '7322581756', 'vimaly@2121gmail.com', '', '', '', NULL, 'fever', '2026-04-10 05:50:39');

-- --------------------------------------------------------

--
-- Table structure for table `patient_admissions`
--

CREATE TABLE `patient_admissions` (
  `admission_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `admitted_by` int(11) DEFAULT NULL,
  `admission_date` datetime NOT NULL DEFAULT current_timestamp(),
  `discharge_date` datetime DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `status` enum('Admitted','Discharged','Transferred','Deceased') DEFAULT 'Admitted',
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_admissions`
--

INSERT INTO `patient_admissions` (`admission_id`, `patient_id`, `room_id`, `admitted_by`, `admission_date`, `discharge_date`, `diagnosis`, `status`, `notes`) VALUES
(1, 1, 2, 1, '2026-03-20 10:30:00', NULL, 'Acute Myocardial Infarction', 'Admitted', NULL),
(2, 3, 5, 3, '2026-03-21 14:00:00', NULL, 'Fractured Femur', 'Admitted', NULL),
(3, 5, 9, 1, '2026-03-23 08:15:00', NULL, 'Chest Pain - Under Observation', 'Admitted', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_date` datetime DEFAULT current_timestamp(),
  `payment_method` enum('Cash','Card','UPI','Net Banking','Insurance','Cheque') NOT NULL,
  `transaction_ref` varchar(100) DEFAULT NULL,
  `received_by` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `bill_id`, `amount`, `payment_date`, `payment_method`, `transaction_ref`, `received_by`, `notes`) VALUES
(1, 1, 10000.00, '2026-04-08 06:55:24', 'UPI', 'UPI20260320ABC', 6, NULL),
(2, 2, 18000.00, '2026-04-08 06:55:24', 'Card', 'CARD20260322XYZ', 6, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pharmacy_dispensing`
--

CREATE TABLE `pharmacy_dispensing` (
  `dispense_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL,
  `medicine_id` int(11) NOT NULL,
  `dispensed_by` int(11) DEFAULT NULL,
  `qty_dispensed` int(11) NOT NULL,
  `dispense_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `prescription_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `issued_date` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescription_items`
--

CREATE TABLE `prescription_items` (
  `item_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL,
  `medicine_id` int(11) NOT NULL,
  `dosage` varchar(80) DEFAULT NULL,
  `frequency` varchar(80) DEFAULT NULL,
  `duration_days` int(11) DEFAULT NULL,
  `qty_prescribed` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_number` varchar(20) NOT NULL,
  `ward_id` int(11) NOT NULL,
  `room_type` enum('Single','Double','Suite','ICU','Emergency') NOT NULL,
  `status` enum('Available','Occupied','Under Maintenance') DEFAULT 'Available',
  `daily_rate` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_number`, `ward_id`, `room_type`, `status`, `daily_rate`) VALUES
(1, 'A-101', 1, 'ICU', 'Available', 5000.00),
(2, 'A-102', 1, 'ICU', 'Occupied', 5000.00),
(3, 'B-201', 2, 'Single', 'Available', 2500.00),
(4, 'B-202', 2, 'Double', 'Available', 1800.00),
(5, 'C-301', 3, 'Single', 'Occupied', 2200.00),
(6, 'D-101', 4, 'Single', 'Available', 2000.00),
(7, 'E-101', 5, 'Double', 'Available', 900.00),
(8, 'E-102', 5, 'Suite', 'Available', 4500.00),
(9, 'ER-01', 6, 'Emergency', 'Occupied', 3500.00);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staff_id` int(11) NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `role` enum('Doctor','Nurse','Pharmacist','Lab Technician','Admin','Receptionist','Support') NOT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `email` varchar(120) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `hire_date` date NOT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `status` enum('Active','Inactive','On Leave') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staff_id`, `first_name`, `last_name`, `role`, `dept_id`, `email`, `phone`, `address`, `gender`, `dob`, `hire_date`, `salary`, `status`, `created_at`) VALUES
(1, 'Arun', 'Sharma', 'Doctor', 1, 'arun.sharma@hospital.com', '9876543210', NULL, 'Male', '1978-05-12', '2010-06-01', 150000.00, 'Active', '2026-04-08 13:52:15'),
(2, 'Priya', 'Mehta', 'Doctor', 2, 'priya.mehta@hospital.com', '9876543211', NULL, 'Female', '1982-08-22', '2012-03-15', 140000.00, 'Active', '2026-04-08 13:52:15'),
(3, 'Rakesh', 'Verma', 'Doctor', 3, 'rakesh.verma@hospital.com', '9876543212', NULL, 'Male', '1975-11-30', '2008-01-10', 160000.00, 'Active', '2026-04-08 13:52:15'),
(4, 'Sunita', 'Singh', 'Nurse', 1, 'sunita.singh@hospital.com', '9876543213', NULL, 'Female', '1990-04-18', '2015-07-01', 45000.00, 'Active', '2026-04-08 13:52:15'),
(5, 'Mohit', 'Jain', 'Pharmacist', 6, 'mohit.jain@hospital.com', '9876543214', NULL, 'Male', '1988-02-14', '2016-09-01', 50000.00, 'Active', '2026-04-08 13:52:15'),
(6, 'Kavita', 'Rao', 'Receptionist', 5, 'kavita.rao@hospital.com', '9876543215', NULL, 'Female', '1993-07-25', '2019-01-15', 35000.00, 'Active', '2026-04-08 13:52:15'),
(7, 'Deepak', 'Gupta', 'Doctor', 4, 'deepak.gupta@hospital.com', '9876543216', NULL, 'Male', '1980-09-07', '2011-04-01', 145000.00, 'Active', '2026-04-08 13:52:15'),
(8, 'Neha', 'Agarwal', 'Admin', 5, 'neha.agarwal@hospital.com', '9876543217', NULL, 'Female', '1985-12-03', '2013-08-01', 60000.00, 'Active', '2026-04-08 13:52:15');

-- --------------------------------------------------------

--
-- Table structure for table `system_users`
--

CREATE TABLE `system_users` (
  `user_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `username` varchar(60) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('Admin','Doctor','Nurse','Pharmacist','Receptionist','Billing') NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_doctor_schedule`
-- (See below for the actual view)
--
CREATE TABLE `vw_doctor_schedule` (
`doctor_id` int(11)
,`doctor_name` varchar(121)
,`specialization` varchar(100)
,`consultation_fee` decimal(10,2)
,`available_days` set('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
,`dept_name` varchar(100)
,`total_appointments_today` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_low_stock_medicines`
-- (See below for the actual view)
--
CREATE TABLE `vw_low_stock_medicines` (
`medicine_id` int(11)
,`name` varchar(150)
,`generic_name` varchar(150)
,`category` varchar(80)
,`stock_qty` int(11)
,`reorder_level` int(11)
,`expiry_date` date
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_outstanding_bills`
-- (See below for the actual view)
--
CREATE TABLE `vw_outstanding_bills` (
`bill_id` int(11)
,`patient_name` varchar(121)
,`bill_date` datetime
,`total_amount` decimal(12,2)
,`paid_amount` decimal(12,2)
,`balance` decimal(12,2)
,`status` enum('Pending','Partial','Paid','Cancelled','Refunded')
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_patient_overview`
-- (See below for the actual view)
--
CREATE TABLE `vw_patient_overview` (
`patient_id` int(11)
,`patient_name` varchar(121)
,`dob` date
,`gender` enum('Male','Female','Other')
,`blood_group` enum('A+','A-','B+','B-','AB+','AB-','O+','O-')
,`phone` varchar(20)
,`admission_id` int(11)
,`admission_date` datetime
,`admission_status` enum('Admitted','Discharged','Transferred','Deceased')
,`room_number` varchar(20)
,`ward_name` varchar(100)
,`attending_doctor` varchar(121)
);

-- --------------------------------------------------------

--
-- Table structure for table `wards`
--

CREATE TABLE `wards` (
  `ward_id` int(11) NOT NULL,
  `ward_name` varchar(100) NOT NULL,
  `ward_type` enum('General','ICU','NICU','Surgery','Maternity','Pediatric','Isolation') NOT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `total_beds` int(11) NOT NULL DEFAULT 0,
  `available_beds` int(11) NOT NULL DEFAULT 0,
  `floor_no` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wards`
--

INSERT INTO `wards` (`ward_id`, `ward_name`, `ward_type`, `dept_id`, `total_beds`, `available_beds`, `floor_no`) VALUES
(1, 'Cardiac Ward', 'ICU', 1, 10, 4, 2),
(2, 'Neuro Ward', 'General', 2, 20, 12, 1),
(3, 'Ortho Ward', 'General', 3, 15, 9, 3),
(4, 'Pediatric Ward', 'Pediatric', 4, 18, 10, 1),
(5, 'General Ward', 'General', 5, 30, 18, 1),
(6, 'Emergency', 'ICU', 5, 8, 3, 0);

-- --------------------------------------------------------

--
-- Structure for view `vw_doctor_schedule`
--
DROP TABLE IF EXISTS `vw_doctor_schedule`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_doctor_schedule`  AS SELECT `d`.`doctor_id` AS `doctor_id`, concat(`s`.`first_name`,' ',`s`.`last_name`) AS `doctor_name`, `d`.`specialization` AS `specialization`, `d`.`consultation_fee` AS `consultation_fee`, `d`.`available_days` AS `available_days`, `dep`.`dept_name` AS `dept_name`, count(`ap`.`appointment_id`) AS `total_appointments_today` FROM (((`doctors` `d` join `staff` `s` on(`s`.`staff_id` = `d`.`staff_id`)) left join `departments` `dep` on(`dep`.`dept_id` = `s`.`dept_id`)) left join `appointments` `ap` on(`ap`.`doctor_id` = `d`.`doctor_id` and `ap`.`appointment_date` = curdate() and `ap`.`status` = 'Scheduled')) GROUP BY `d`.`doctor_id`, concat(`s`.`first_name`,' ',`s`.`last_name`), `d`.`specialization`, `d`.`consultation_fee`, `d`.`available_days`, `dep`.`dept_name` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_low_stock_medicines`
--
DROP TABLE IF EXISTS `vw_low_stock_medicines`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_low_stock_medicines`  AS SELECT `medicines`.`medicine_id` AS `medicine_id`, `medicines`.`name` AS `name`, `medicines`.`generic_name` AS `generic_name`, `medicines`.`category` AS `category`, `medicines`.`stock_qty` AS `stock_qty`, `medicines`.`reorder_level` AS `reorder_level`, `medicines`.`expiry_date` AS `expiry_date` FROM `medicines` WHERE `medicines`.`stock_qty` <= `medicines`.`reorder_level` ORDER BY `medicines`.`stock_qty` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `vw_outstanding_bills`
--
DROP TABLE IF EXISTS `vw_outstanding_bills`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_outstanding_bills`  AS SELECT `b`.`bill_id` AS `bill_id`, concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`, `b`.`bill_date` AS `bill_date`, `b`.`total_amount` AS `total_amount`, `b`.`paid_amount` AS `paid_amount`, `b`.`balance` AS `balance`, `b`.`status` AS `status` FROM (`bills` `b` join `patients` `p` on(`p`.`patient_id` = `b`.`patient_id`)) WHERE `b`.`status` in ('Pending','Partial') ORDER BY `b`.`balance` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `vw_patient_overview`
--
DROP TABLE IF EXISTS `vw_patient_overview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_patient_overview`  AS SELECT `p`.`patient_id` AS `patient_id`, concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`, `p`.`dob` AS `dob`, `p`.`gender` AS `gender`, `p`.`blood_group` AS `blood_group`, `p`.`phone` AS `phone`, `a`.`admission_id` AS `admission_id`, `a`.`admission_date` AS `admission_date`, `a`.`status` AS `admission_status`, `r`.`room_number` AS `room_number`, `w`.`ward_name` AS `ward_name`, concat(`s`.`first_name`,' ',`s`.`last_name`) AS `attending_doctor` FROM (((((`patients` `p` left join `patient_admissions` `a` on(`a`.`patient_id` = `p`.`patient_id` and `a`.`status` = 'Admitted')) left join `rooms` `r` on(`r`.`room_id` = `a`.`room_id`)) left join `wards` `w` on(`w`.`ward_id` = `r`.`ward_id`)) left join `doctors` `doc` on(`doc`.`doctor_id` = `a`.`admitted_by`)) left join `staff` `s` on(`s`.`staff_id` = `doc`.`staff_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`bill_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `admission_id` (`admission_id`),
  ADD KEY `appointment_id` (`appointment_id`);

--
-- Indexes for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `bill_id` (`bill_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD KEY `fk_dept_head` (`head_doctor_id`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`doctor_id`),
  ADD UNIQUE KEY `staff_id` (`staff_id`),
  ADD UNIQUE KEY `license_number` (`license_number`);

--
-- Indexes for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD PRIMARY KEY (`claim_id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- Indexes for table `medicines`
--
ALTER TABLE `medicines`
  ADD PRIMARY KEY (`medicine_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`patient_id`);

--
-- Indexes for table `patient_admissions`
--
ALTER TABLE `patient_admissions`
  ADD PRIMARY KEY (`admission_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `admitted_by` (`admitted_by`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `received_by` (`received_by`);

--
-- Indexes for table `pharmacy_dispensing`
--
ALTER TABLE `pharmacy_dispensing`
  ADD PRIMARY KEY (`dispense_id`),
  ADD KEY `prescription_id` (`prescription_id`),
  ADD KEY `medicine_id` (`medicine_id`),
  ADD KEY `dispensed_by` (`dispensed_by`);

--
-- Indexes for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`prescription_id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `appointment_id` (`appointment_id`);

--
-- Indexes for table `prescription_items`
--
ALTER TABLE `prescription_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `prescription_id` (`prescription_id`),
  ADD KEY `medicine_id` (`medicine_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`),
  ADD UNIQUE KEY `room_number` (`room_number`),
  ADD KEY `ward_id` (`ward_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staff_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `dept_id` (`dept_id`);

--
-- Indexes for table `system_users`
--
ALTER TABLE `system_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `staff_id` (`staff_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `wards`
--
ALTER TABLE `wards`
  ADD PRIMARY KEY (`ward_id`),
  ADD KEY `dept_id` (`dept_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `bill_items`
--
ALTER TABLE `bill_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  MODIFY `claim_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicines`
--
ALTER TABLE `medicines`
  MODIFY `medicine_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `patient_admissions`
--
ALTER TABLE `patient_admissions`
  MODIFY `admission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pharmacy_dispensing`
--
ALTER TABLE `pharmacy_dispensing`
  MODIFY `dispense_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `prescription_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescription_items`
--
ALTER TABLE `prescription_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `staff_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `system_users`
--
ALTER TABLE `system_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wards`
--
ALTER TABLE `wards`
  MODIFY `ward_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE;

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bills_ibfk_2` FOREIGN KEY (`admission_id`) REFERENCES `patient_admissions` (`admission_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `bills_ibfk_3` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE SET NULL;

--
-- Constraints for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD CONSTRAINT `bill_items_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`) ON DELETE CASCADE;

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `fk_dept_head` FOREIGN KEY (`head_doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE SET NULL;

--
-- Constraints for table `doctors`
--
ALTER TABLE `doctors`
  ADD CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE;

--
-- Constraints for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD CONSTRAINT `insurance_claims_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `insurance_claims_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE;

--
-- Constraints for table `patient_admissions`
--
ALTER TABLE `patient_admissions`
  ADD CONSTRAINT `patient_admissions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `patient_admissions_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `patient_admissions_ibfk_3` FOREIGN KEY (`admitted_by`) REFERENCES `doctors` (`doctor_id`) ON DELETE SET NULL;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`received_by`) REFERENCES `staff` (`staff_id`) ON DELETE SET NULL;

--
-- Constraints for table `pharmacy_dispensing`
--
ALTER TABLE `pharmacy_dispensing`
  ADD CONSTRAINT `pharmacy_dispensing_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions` (`prescription_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pharmacy_dispensing_ibfk_2` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`medicine_id`),
  ADD CONSTRAINT `pharmacy_dispensing_ibfk_3` FOREIGN KEY (`dispensed_by`) REFERENCES `staff` (`staff_id`) ON DELETE SET NULL;

--
-- Constraints for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prescriptions_ibfk_3` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE SET NULL;

--
-- Constraints for table `prescription_items`
--
ALTER TABLE `prescription_items`
  ADD CONSTRAINT `prescription_items_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions` (`prescription_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prescription_items_ibfk_2` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`medicine_id`);

--
-- Constraints for table `rooms`
--
ALTER TABLE `rooms`
  ADD CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`ward_id`) REFERENCES `wards` (`ward_id`) ON DELETE CASCADE;

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE SET NULL;

--
-- Constraints for table `system_users`
--
ALTER TABLE `system_users`
  ADD CONSTRAINT `system_users_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE;

--
-- Constraints for table `wards`
--
ALTER TABLE `wards`
  ADD CONSTRAINT `wards_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
