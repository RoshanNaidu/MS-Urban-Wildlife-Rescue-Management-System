-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: mysql:3306
-- Generation Time: Dec 14, 2025 at 01:15 AM
-- Server version: 8.0.44
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uwrms`
--
CREATE DATABASE IF NOT EXISTS `uwrms` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `uwrms`;

-- --------------------------------------------------------

--
-- Table structure for table `ANIMAL`
--

DROP TABLE IF EXISTS `ANIMAL`;
CREATE TABLE `ANIMAL` (
  `ANIMAL_ID` int UNSIGNED NOT NULL,
  `INCIDENT_ID` int UNSIGNED NOT NULL,
  `SPECIES_ID` int UNSIGNED NOT NULL,
  `ANIMAL_AGE_CATEGORY` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ANIMAL_SEX` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ANIMAL_HEALTH_STATUS` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ANIMAL_INTAKE_DATE` date NOT NULL,
  `ANIMAL_IDENTIFICATION_MARK` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ANIMAL`
--

INSERT INTO `ANIMAL` (`ANIMAL_ID`, `INCIDENT_ID`, `SPECIES_ID`, `ANIMAL_AGE_CATEGORY`, `ANIMAL_SEX`, `ANIMAL_HEALTH_STATUS`, `ANIMAL_INTAKE_DATE`, `ANIMAL_IDENTIFICATION_MARK`) VALUES
(1001, 5001, 301, 'Adult', 'Female', 'Injured', '2025-01-10', 'TAG-A77'),
(1002, 5002, 302, 'Infant', 'Unknown', 'Weak', '2025-01-11', 'TAG-B12'),
(1003, 5003, 305, 'Adult', 'Male', 'Injured', '2025-01-09', 'BAND-BC02'),
(1004, 5004, 307, 'Teen', 'Male', 'Malnourished', '2025-01-12', 'CHIP-991C'),
(1005, 5005, 301, 'Adult', 'Female', 'Respiratory', '2025-01-13', 'TAG-D18');

-- --------------------------------------------------------

--
-- Table structure for table `ANIMAL_FACILITY_ASSIGNMENT`
--

DROP TABLE IF EXISTS `ANIMAL_FACILITY_ASSIGNMENT`;
CREATE TABLE `ANIMAL_FACILITY_ASSIGNMENT` (
  `ANIMAL_FACILITY_ASSIGNMENT_ID` int UNSIGNED NOT NULL,
  `ANIMAL_ID` int UNSIGNED NOT NULL,
  `FACILITY_ID` int UNSIGNED NOT NULL,
  `ANIMAL_FACILITY_ASSIGNMENT_ADMISSION_DATE` date NOT NULL,
  `ANIMAL_FACILITY_ASSIGNMENT_DISCHARGE_DATE` date DEFAULT NULL,
  `ANIMAL_FACILITY_ASSIGNMENT_ENCLOSURE_NUMBER` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ANIMAL_FACILITY_ASSIGNMENT_CARE_LEVEL` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ANIMAL_FACILITY_ASSIGNMENT`
--

INSERT INTO `ANIMAL_FACILITY_ASSIGNMENT` (`ANIMAL_FACILITY_ASSIGNMENT_ID`, `ANIMAL_ID`, `FACILITY_ID`, `ANIMAL_FACILITY_ASSIGNMENT_ADMISSION_DATE`, `ANIMAL_FACILITY_ASSIGNMENT_DISCHARGE_DATE`, `ANIMAL_FACILITY_ASSIGNMENT_ENCLOSURE_NUMBER`, `ANIMAL_FACILITY_ASSIGNMENT_CARE_LEVEL`) VALUES
(950001, 1001, 201, '2025-01-10', '2025-01-18', 'ENC-14', 'Intensive'),
(950002, 1002, 201, '2025-01-11', '2025-01-18', 'ENC-07', 'Basic'),
(950003, 1003, 202, '2025-01-09', '2025-01-15', 'ENC-03', 'Critical'),
(950004, 1004, 203, '2025-01-12', '2025-01-18', 'ENC-22', 'Intensive'),
(950005, 1005, 203, '2025-01-13', '2025-01-18', 'ENC-19', 'Basic');

-- --------------------------------------------------------

--
-- Table structure for table `ASSIGNMENT`
--

DROP TABLE IF EXISTS `ASSIGNMENT`;
CREATE TABLE `ASSIGNMENT` (
  `ASSIGNMENT_ID` int UNSIGNED NOT NULL,
  `INCIDENT_ID` int UNSIGNED NOT NULL,
  `RESPONDER_ID` int UNSIGNED NOT NULL,
  `ASSIGNMENT_DATE` datetime NOT NULL,
  `ASSIGNMENT_STATUS` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ASSIGNMENT_NOTES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ASSIGNMENT`
--

INSERT INTO `ASSIGNMENT` (`ASSIGNMENT_ID`, `INCIDENT_ID`, `RESPONDER_ID`, `ASSIGNMENT_DATE`, `ASSIGNMENT_STATUS`, `ASSIGNMENT_NOTES`) VALUES
(80001, 5001, 7001, '2025-01-10 09:30:00', 'Completed', 'On-site capture and transport'),
(80002, 5002, 7004, '2025-01-11 14:40:00', 'Completed', 'Assisted intake at facility'),
(80003, 5003, 7002, '2025-01-09 08:30:00', 'Completed', 'Raptor stabilization'),
(80004, 5004, 7005, '2025-01-12 11:20:00', 'Completed', 'Safe extraction support'),
(80005, 5005, 7003, '2025-01-13 19:15:00', 'In Progress', 'Monitor smoke exposure cases');

-- --------------------------------------------------------

--
-- Table structure for table `CARNIVORE`
--

DROP TABLE IF EXISTS `CARNIVORE`;
CREATE TABLE `CARNIVORE` (
  `SPECIES_ID` int UNSIGNED NOT NULL,
  `CARNIVORE_PREY_PREFERENCE` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `CARNIVORE`
--

INSERT INTO `CARNIVORE` (`SPECIES_ID`, `CARNIVORE_PREY_PREFERENCE`) VALUES
(301, 'Small mammals'),
(305, 'Rodents'),
(306, 'Mice'),
(307, 'Rabbits'),
(310, 'Fish');

-- --------------------------------------------------------

--
-- Table structure for table `FACILITY`
--

DROP TABLE IF EXISTS `FACILITY`;
CREATE TABLE `FACILITY` (
  `FACILITY_ID` int UNSIGNED NOT NULL,
  `PERMIT_ID` int UNSIGNED NOT NULL,
  `FACILITY_NAME` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FACILITY_ADDRESS` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FACILITY_CITY` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FACILITY_CAPACITY` int UNSIGNED NOT NULL,
  `FACILITY_TYPE` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FACILITY_CONTACT` char(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FACILITY_EMAIL` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `FACILITY`
--

INSERT INTO `FACILITY` (`FACILITY_ID`, `PERMIT_ID`, `FACILITY_NAME`, `FACILITY_ADDRESS`, `FACILITY_CITY`, `FACILITY_CAPACITY`, `FACILITY_TYPE`, `FACILITY_CONTACT`, `FACILITY_EMAIL`) VALUES
(201, 90011, 'GreenPaws Wildlife Center', '42 Riverbank Road', 'Riverside', 60, 'Rehab', '555-219-8890', 'info@greenpaws.org'),
(202, 90009, 'FeatherCare Aviary', '9 Cliff Edge Ave', 'Hillview', 45, 'Avian-Center', '555-441-9987', 'care@featheraviary.net'),
(203, 90015, 'WildHaven Rescue Shelter', '77 Cedar Trail', 'Brookside', 35, 'Mammal-Center', '555-337-2299', 'contact@wildhaven.org'),
(204, 90021, 'Lakeshore Vet Sanctuary', '120 Lakepoint Drive', 'Westport', 25, 'Clinic', '555-771-9822', 'help@lakeshorevet.org'),
(205, 90033, 'Northwoods Wildlife Care', '5 Pine Ridge', 'Northgate', 40, 'Rehab', '555-440-9912', 'admin@northwoods.org');

-- --------------------------------------------------------

--
-- Table structure for table `HERBIVORE`
--

DROP TABLE IF EXISTS `HERBIVORE`;
CREATE TABLE `HERBIVORE` (
  `SPECIES_ID` int UNSIGNED NOT NULL,
  `HERBIVORE_PLANT_PREFERENCE` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `HERBIVORE`
--

INSERT INTO `HERBIVORE` (`SPECIES_ID`, `HERBIVORE_PLANT_PREFERENCE`) VALUES
(320, 'Grasses'),
(321, 'Leaves'),
(322, 'Bark'),
(323, 'Aquatic plants'),
(324, 'Shrubs');

-- --------------------------------------------------------

--
-- Table structure for table `INCIDENT`
--

DROP TABLE IF EXISTS `INCIDENT`;
CREATE TABLE `INCIDENT` (
  `INCIDENT_ID` int UNSIGNED NOT NULL,
  `INCIDENT_DATE` datetime NOT NULL,
  `INCIDENT_TYPE` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INCIDENT_LOCATION` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INCIDENT_REPORTED_NAME` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INCIDENT_REPORTED_CONTACT` char(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INCIDENT_STATUS` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INCIDENT_RESOLUTION_DATE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `INCIDENT`
--

INSERT INTO `INCIDENT` (`INCIDENT_ID`, `INCIDENT_DATE`, `INCIDENT_TYPE`, `INCIDENT_LOCATION`, `INCIDENT_REPORTED_NAME`, `INCIDENT_REPORTED_CONTACT`, `INCIDENT_STATUS`, `INCIDENT_RESOLUTION_DATE`) VALUES
(5001, '2025-01-10 09:15:00', 'Injury', 'Downtown Crossing', 'Mark Peters', '555-210-8841', 'Resolved', '2025-01-20'),
(5002, '2025-01-11 14:22:00', 'Orphaned', 'Lakeside Park', 'Sarah Mills', '555-883-2277', 'Resolved', '2025-01-20'),
(5003, '2025-01-09 07:40:00', 'Injury', 'Old Mill Bridge', 'Daniel Craig', '555-992-1183', 'Resolved', '2025-01-15'),
(5004, '2025-01-12 11:05:00', 'Trapped', 'Forest Lane', 'Oliver Tan', '555-663-2291', 'Resolved', '2025-01-20'),
(5005, '2025-01-13 18:30:00', 'Pollution', 'Riverside Docks', 'Fiona Wells', '555-320-8820', 'Resolved', '2025-01-20');

-- --------------------------------------------------------

--
-- Table structure for table `INVENTORY`
--

DROP TABLE IF EXISTS `INVENTORY`;
CREATE TABLE `INVENTORY` (
  `INVENTORY_ID` int UNSIGNED NOT NULL,
  `ANIMAL_FACILITY_ASSIGNMENT_ID` int UNSIGNED NOT NULL,
  `INVENTORY_ITEM_NAME` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INVENTORY_CATEGORY` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INVENTORY_QUANTITY` int UNSIGNED NOT NULL,
  `INVENTORY_UNIT` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INVENTORY_REORDER_LEVEL` int UNSIGNED NOT NULL,
  `INVENTORY_LAST_UPDATED` datetime NOT NULL,
  `INVENTORY_SUPPLIER_NAME` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `INVENTORY`
--

INSERT INTO `INVENTORY` (`INVENTORY_ID`, `ANIMAL_FACILITY_ASSIGNMENT_ID`, `INVENTORY_ITEM_NAME`, `INVENTORY_CATEGORY`, `INVENTORY_QUANTITY`, `INVENTORY_UNIT`, `INVENTORY_REORDER_LEVEL`, `INVENTORY_LAST_UPDATED`, `INVENTORY_SUPPLIER_NAME`) VALUES
(30001, 950001, 'Bandages', 'Medical', 40, 'pcs', 15, '2025-01-18 08:00:00', 'MedSupply Co'),
(30002, 950002, 'Electrolyte Solution', 'Medical', 5, 'bottles', 2, '2025-01-18 08:05:00', 'VetPharm'),
(30003, 950003, 'Wing Wrap', 'Medical', 10, 'pcs', 4, '2025-01-15 07:30:00', 'Aviary Essentials'),
(30004, 950004, 'High-Calorie Feed', 'Nutrition', 8, 'kg', 3, '2025-01-18 09:10:00', 'WildFeeders'),
(30005, 950005, 'Respiratory Kit', 'Medical', 2, 'kits', 1, '2025-01-14 10:45:00', 'ClinicPro');

-- --------------------------------------------------------

--
-- Table structure for table `OMNIVORE`
--

DROP TABLE IF EXISTS `OMNIVORE`;
CREATE TABLE `OMNIVORE` (
  `SPECIES_ID` int UNSIGNED NOT NULL,
  `OMNIVORE_PLANT_RATIO` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `OMNIVORE_PREY_RATIO` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `OMNIVORE`
--

INSERT INTO `OMNIVORE` (`SPECIES_ID`, `OMNIVORE_PLANT_RATIO`, `OMNIVORE_PREY_RATIO`) VALUES
(302, '60% plants', '40% prey'),
(309, '50% plants', '50% prey'),
(311, '70% plants', '30% prey'),
(312, '55% plants', '45% prey'),
(313, '65% plants', '35% prey');

-- --------------------------------------------------------

--
-- Table structure for table `PERMIT`
--

DROP TABLE IF EXISTS `PERMIT`;
CREATE TABLE `PERMIT` (
  `PERMIT_ID` int UNSIGNED NOT NULL,
  `PERMIT_TYPE` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PERMIT_ISSUED_TO` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PERMIT_ISSUE_DATE` date NOT NULL,
  `PERMIT_EXPIRY_DATE` date NOT NULL,
  `PERMIT_REGULATORY_AGENCY` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PERMIT_STATUS` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PERMIT_NOTES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `PERMIT`
--

INSERT INTO `PERMIT` (`PERMIT_ID`, `PERMIT_TYPE`, `PERMIT_ISSUED_TO`, `PERMIT_ISSUE_DATE`, `PERMIT_EXPIRY_DATE`, `PERMIT_REGULATORY_AGENCY`, `PERMIT_STATUS`, `PERMIT_NOTES`) VALUES
(90009, 'Avian Care Permit', 'FeatherCare Aviary', '2023-06-15', '2026-06-15', 'State Wildlife Dept', 'Active', 'Raptor and avian care'),
(90011, 'Wildlife Rehab Permit', 'GreenPaws Wildlife Center', '2024-01-01', '2026-01-01', 'State Wildlife Dept', 'Active', 'General rehab permit'),
(90015, 'Mammal Rescue Permit', 'WildHaven Rescue Shelter', '2024-03-10', '2026-03-10', 'State Wildlife Dept', 'Active', 'Mammal intake/rehab'),
(90021, 'Veterinary Facility Permit', 'Lakeshore Vet Sanctuary', '2024-02-20', '2026-02-20', 'State Vet Board', 'Active', 'Clinic operations'),
(90033, 'Wildlife Rehab Permit', 'Northwoods Wildlife Care', '2024-04-01', '2026-04-01', 'State Wildlife Dept', 'Active', 'Rehab capacity 40');

-- --------------------------------------------------------

--
-- Table structure for table `RELEASE`
--

DROP TABLE IF EXISTS `RELEASE`;
CREATE TABLE `RELEASE` (
  `RELEASE_ID` int UNSIGNED NOT NULL,
  `ANIMAL_ID` int UNSIGNED NOT NULL,
  `RELEASE_DATE` date NOT NULL,
  `RELEASE_LOCATION` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RELEASE_CONDITION` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RELEASE_FOLLOWUP_STATUS` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RELEASE_BY` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RELEASE_NOTTES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `RELEASE`
--

INSERT INTO `RELEASE` (`RELEASE_ID`, `ANIMAL_ID`, `RELEASE_DATE`, `RELEASE_LOCATION`, `RELEASE_CONDITION`, `RELEASE_FOLLOWUP_STATUS`, `RELEASE_BY`, `RELEASE_NOTTES`) VALUES
(60001, 1001, '2025-01-20', 'Riverside Greenbelt', 'Recovered', 'Completed', 'Erin Chen', 'Released near original territory'),
(60002, 1002, '2025-01-20', 'Lakeside Park', 'Recovered', 'Scheduled', 'Asha Patel', 'Follow-up in 2 weeks'),
(60003, 1003, '2025-01-15', 'Hillview Cliffs', 'Recovered', 'Completed', 'Miguel Santos', 'Flight test passed'),
(60004, 1004, '2025-01-20', 'Forest Lane Reserve', 'Recovered', 'Scheduled', 'Priya Nair', 'Tag tracking enabled'),
(60005, 1005, '2025-01-20', 'Riverside Edge', 'Recovered', 'Scheduled', 'Miguel Santos', 'Monitor for recurrence');

-- --------------------------------------------------------

--
-- Table structure for table `RESPONDER`
--

DROP TABLE IF EXISTS `RESPONDER`;
CREATE TABLE `RESPONDER` (
  `RESPONDER_ID` int UNSIGNED NOT NULL,
  `RESPONDER_FULL_NAME` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RESPONDER_ROLE` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RESPONDER_CERTIFICATION_LEVEL` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESPONDER_CONTACT` char(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RESPONDER_EMAIL` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RESPONDER_AVAILABILITY` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RESPONDER_JOIN_DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `RESPONDER`
--

INSERT INTO `RESPONDER` (`RESPONDER_ID`, `RESPONDER_FULL_NAME`, `RESPONDER_ROLE`, `RESPONDER_CERTIFICATION_LEVEL`, `RESPONDER_CONTACT`, `RESPONDER_EMAIL`, `RESPONDER_AVAILABILITY`, `RESPONDER_JOIN_DATE`) VALUES
(7001, 'Asha Patel', 'Field Rescuer', 'Level 2', '555-101-0001', 'asha.patel@uwrms.org', 'Available', '2023-05-10'),
(7002, 'Miguel Santos', 'Veterinarian', 'DVM', '555-101-0002', 'miguel.santos@uwrms.org', 'Available', '2022-11-03'),
(7003, 'Erin Chen', 'Rehab Coordinator', 'Level 3', '555-101-0003', 'erin.chen@uwrms.org', 'On Call', '2024-01-15'),
(7004, 'Noah Johnson', 'Volunteer Rescuer', 'Level 1', '555-101-0004', 'noah.johnson@uwrms.org', 'Unavailable', '2024-06-01'),
(7005, 'Priya Nair', 'Wildlife Tech', 'Level 2', '555-101-0005', 'priya.nair@uwrms.org', 'Available', '2023-09-20');

-- --------------------------------------------------------

--
-- Table structure for table `SPECIES`
--

DROP TABLE IF EXISTS `SPECIES`;
CREATE TABLE `SPECIES` (
  `SPECIES_ID` int UNSIGNED NOT NULL,
  `SPECIES_COMMON_NAME` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SPECIES_SCIENTIFIC_NAME` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SPECIES_DIET_TYPE` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SPECIES_CONSERVATION_STATUS` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SPECIES_HABITAT_TYPE` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SPECIES_NOTES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `SPECIES`
--

INSERT INTO `SPECIES` (`SPECIES_ID`, `SPECIES_COMMON_NAME`, `SPECIES_SCIENTIFIC_NAME`, `SPECIES_DIET_TYPE`, `SPECIES_CONSERVATION_STATUS`, `SPECIES_HABITAT_TYPE`, `SPECIES_NOTES`) VALUES
(301, 'Red Fox', 'Vulpes vulpes', 'Carnivore', 'Least Concern', 'Forest/Urban Edge', 'Common urban fox'),
(302, 'Raccoon', 'Procyon lotor', 'Omnivore', 'Least Concern', 'Woodland/Urban', 'Orphan found in park'),
(305, 'Red-Tailed Hawk', 'Buteo jamaicensis', 'Carnivore', 'Least Concern', 'Grassland/Cliffs', 'Transport collision risk'),
(306, 'Barn Owl', 'Tyto alba', 'Carnivore', 'Least Concern', 'Farmland/Woodland', 'Often roadside strikes'),
(307, 'Coyote', 'Canis latrans', 'Carnivore', 'Least Concern', 'Woodlands', 'Occasional roadside capture'),
(309, 'Striped Skunk', 'Mephitis mephitis', 'Omnivore', 'Least Concern', 'Grassland', 'Treatable conditions common'),
(310, 'Harbor Seal', 'Phoca vitulina', 'Carnivore', 'Least Concern', 'Coastal Marine', 'Entanglement risk'),
(311, 'Opossum', 'Didelphis virginiana', 'Omnivore', 'Least Concern', 'Urban/Woodland', 'Generalist feeder'),
(312, 'Crow', 'Corvus brachyrhynchos', 'Omnivore', 'Least Concern', 'Urban', 'Highly adaptable'),
(313, 'Black Bear', 'Ursus americanus', 'Omnivore', 'Least Concern', 'Forest', 'Seasonal movement'),
(320, 'White-tailed Deer', 'Odocoileus virginianus', 'Herbivore', 'Least Concern', 'Woodland', 'Common in suburban edges'),
(321, 'Eastern Cottontail', 'Sylvilagus floridanus', 'Herbivore', 'Least Concern', 'Meadow', 'Frequent orphan calls'),
(322, 'American Beaver', 'Castor canadensis', 'Herbivore', 'Least Concern', 'Wetlands', 'Dam-related incidents'),
(323, 'Manatee', 'Trichechus manatus', 'Herbivore', 'Vulnerable', 'Coastal/Estuary', 'Boat strike risk'),
(324, 'Mountain Goat', 'Oreamnos americanus', 'Herbivore', 'Least Concern', 'Alpine', 'Occasional rescue');

-- --------------------------------------------------------

--
-- Table structure for table `STAFF`
--

DROP TABLE IF EXISTS `STAFF`;
CREATE TABLE `STAFF` (
  `STAFF_ID` int UNSIGNED NOT NULL,
  `FACILITY_ID` int UNSIGNED NOT NULL,
  `STAFF_FULL_NAME` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STAFF_POSITION` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STAFF_SHIFT` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STAFF_HIRE_DATE` date NOT NULL,
  `STAFF_CONTACT` char(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STAFF_EMAIL` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `STAFF`
--

INSERT INTO `STAFF` (`STAFF_ID`, `FACILITY_ID`, `STAFF_FULL_NAME`, `STAFF_POSITION`, `STAFF_SHIFT`, `STAFF_HIRE_DATE`, `STAFF_CONTACT`, `STAFF_EMAIL`) VALUES
(40001, 201, 'Liam Brooks', 'Intake Specialist', 'Day', '2022-02-01', '555-201-0001', 'liam.brooks@greenpaws.org'),
(40002, 202, 'Sofia Reed', 'Aviary Tech', 'Day', '2021-08-15', '555-201-0002', 'sofia.reed@feathercare.org'),
(40003, 203, 'Harper Kim', 'Rehab Assistant', 'Night', '2023-03-10', '555-201-0003', 'harper.kim@wildhaven.org'),
(40004, 204, 'Ethan Ward', 'Vet Nurse', 'Day', '2020-11-20', '555-201-0004', 'ethan.ward@lakeshorevet.org'),
(40005, 205, 'Maya Singh', 'Caregiver', 'Evening', '2024-05-05', '555-201-0005', 'maya.singh@northwoods.org');

-- --------------------------------------------------------

--
-- Table structure for table `TREATMENT`
--

DROP TABLE IF EXISTS `TREATMENT`;
CREATE TABLE `TREATMENT` (
  `TREATMENT_ID` int UNSIGNED NOT NULL,
  `ANIMAL_ID` int UNSIGNED NOT NULL,
  `RESPONDER_ID` int UNSIGNED NOT NULL,
  `TREATMENT_DATE` datetime NOT NULL,
  `TREATMENT_PROCEDURE_TYPE` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TREATMENT_MEDICATION` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TREATMENT_DOSAGE` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TREATMENT_OUTCOME` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TREATMENT_NOTES` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `TREATMENT`
--

INSERT INTO `TREATMENT` (`TREATMENT_ID`, `ANIMAL_ID`, `RESPONDER_ID`, `TREATMENT_DATE`, `TREATMENT_PROCEDURE_TYPE`, `TREATMENT_MEDICATION`, `TREATMENT_DOSAGE`, `TREATMENT_OUTCOME`, `TREATMENT_NOTES`) VALUES
(900001, 1001, 7002, '2025-01-10 11:00:00', 'Wound Cleaning', 'Antibiotic', '50mg', 'Improving', 'Cleaned and bandaged'),
(900002, 1003, 7002, '2025-01-09 09:15:00', 'Fracture Stabilization', 'Pain Relief', '10mg', 'Stable', 'Wing splint applied'),
(900003, 1002, 7005, '2025-01-11 15:10:00', 'Hydration Therapy', 'Fluids', '100ml', 'Improving', 'Monitored intake'),
(900004, 1004, 7002, '2025-01-12 12:30:00', 'Nutrition Support', NULL, NULL, 'Improving', 'High-calorie diet'),
(900005, 1005, 7002, '2025-01-13 20:00:00', 'Respiratory Assessment', 'Bronchodilator', '5mg', 'Stable', 'Observed breathing');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ANIMAL`
--
ALTER TABLE `ANIMAL`
  ADD PRIMARY KEY (`ANIMAL_ID`),
  ADD KEY `fk_animal_incident` (`INCIDENT_ID`),
  ADD KEY `fk_animal_species` (`SPECIES_ID`);

--
-- Indexes for table `ANIMAL_FACILITY_ASSIGNMENT`
--
ALTER TABLE `ANIMAL_FACILITY_ASSIGNMENT`
  ADD PRIMARY KEY (`ANIMAL_FACILITY_ASSIGNMENT_ID`),
  ADD UNIQUE KEY `uq_afa_animal_facility_admit` (`ANIMAL_ID`,`FACILITY_ID`,`ANIMAL_FACILITY_ASSIGNMENT_ADMISSION_DATE`),
  ADD KEY `fk_afa_facility` (`FACILITY_ID`);

--
-- Indexes for table `ASSIGNMENT`
--
ALTER TABLE `ASSIGNMENT`
  ADD PRIMARY KEY (`ASSIGNMENT_ID`),
  ADD UNIQUE KEY `uq_assignment_incident` (`INCIDENT_ID`),
  ADD KEY `fk_assignment_responder` (`RESPONDER_ID`);

--
-- Indexes for table `CARNIVORE`
--
ALTER TABLE `CARNIVORE`
  ADD PRIMARY KEY (`SPECIES_ID`);

--
-- Indexes for table `FACILITY`
--
ALTER TABLE `FACILITY`
  ADD PRIMARY KEY (`FACILITY_ID`),
  ADD KEY `fk_facility_permit` (`PERMIT_ID`);

--
-- Indexes for table `HERBIVORE`
--
ALTER TABLE `HERBIVORE`
  ADD PRIMARY KEY (`SPECIES_ID`);

--
-- Indexes for table `INCIDENT`
--
ALTER TABLE `INCIDENT`
  ADD PRIMARY KEY (`INCIDENT_ID`);

--
-- Indexes for table `INVENTORY`
--
ALTER TABLE `INVENTORY`
  ADD PRIMARY KEY (`INVENTORY_ID`),
  ADD KEY `fk_inventory_afa` (`ANIMAL_FACILITY_ASSIGNMENT_ID`);

--
-- Indexes for table `OMNIVORE`
--
ALTER TABLE `OMNIVORE`
  ADD PRIMARY KEY (`SPECIES_ID`);

--
-- Indexes for table `PERMIT`
--
ALTER TABLE `PERMIT`
  ADD PRIMARY KEY (`PERMIT_ID`);

--
-- Indexes for table `RELEASE`
--
ALTER TABLE `RELEASE`
  ADD PRIMARY KEY (`RELEASE_ID`),
  ADD UNIQUE KEY `release_id_UNIQUE` (`RELEASE_ID`) INVISIBLE,
  ADD UNIQUE KEY `animal_id_UNIQUE` (`ANIMAL_ID`);

--
-- Indexes for table `RESPONDER`
--
ALTER TABLE `RESPONDER`
  ADD PRIMARY KEY (`RESPONDER_ID`);

--
-- Indexes for table `SPECIES`
--
ALTER TABLE `SPECIES`
  ADD PRIMARY KEY (`SPECIES_ID`);

--
-- Indexes for table `STAFF`
--
ALTER TABLE `STAFF`
  ADD PRIMARY KEY (`STAFF_ID`),
  ADD KEY `fk_staff_facility` (`FACILITY_ID`);

--
-- Indexes for table `TREATMENT`
--
ALTER TABLE `TREATMENT`
  ADD PRIMARY KEY (`TREATMENT_ID`),
  ADD KEY `fk_treatment_animal` (`ANIMAL_ID`),
  ADD KEY `fk_treatment_responder` (`RESPONDER_ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ANIMAL`
--
ALTER TABLE `ANIMAL`
  ADD CONSTRAINT `fk_animal_incident` FOREIGN KEY (`INCIDENT_ID`) REFERENCES `INCIDENT` (`INCIDENT_ID`),
  ADD CONSTRAINT `fk_animal_species` FOREIGN KEY (`SPECIES_ID`) REFERENCES `SPECIES` (`SPECIES_ID`);

--
-- Constraints for table `ANIMAL_FACILITY_ASSIGNMENT`
--
ALTER TABLE `ANIMAL_FACILITY_ASSIGNMENT`
  ADD CONSTRAINT `fk_afa_animal` FOREIGN KEY (`ANIMAL_ID`) REFERENCES `ANIMAL` (`ANIMAL_ID`),
  ADD CONSTRAINT `fk_afa_facility` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`FACILITY_ID`);

--
-- Constraints for table `ASSIGNMENT`
--
ALTER TABLE `ASSIGNMENT`
  ADD CONSTRAINT `fk_assignment_incident` FOREIGN KEY (`INCIDENT_ID`) REFERENCES `INCIDENT` (`INCIDENT_ID`),
  ADD CONSTRAINT `fk_assignment_responder` FOREIGN KEY (`RESPONDER_ID`) REFERENCES `RESPONDER` (`RESPONDER_ID`);

--
-- Constraints for table `CARNIVORE`
--
ALTER TABLE `CARNIVORE`
  ADD CONSTRAINT `fk_carnivore_species` FOREIGN KEY (`SPECIES_ID`) REFERENCES `SPECIES` (`SPECIES_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `FACILITY`
--
ALTER TABLE `FACILITY`
  ADD CONSTRAINT `fk_facility_permit` FOREIGN KEY (`PERMIT_ID`) REFERENCES `PERMIT` (`PERMIT_ID`);

--
-- Constraints for table `HERBIVORE`
--
ALTER TABLE `HERBIVORE`
  ADD CONSTRAINT `fk_herbivore_species` FOREIGN KEY (`SPECIES_ID`) REFERENCES `SPECIES` (`SPECIES_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `INVENTORY`
--
ALTER TABLE `INVENTORY`
  ADD CONSTRAINT `fk_inventory_afa` FOREIGN KEY (`ANIMAL_FACILITY_ASSIGNMENT_ID`) REFERENCES `ANIMAL_FACILITY_ASSIGNMENT` (`ANIMAL_FACILITY_ASSIGNMENT_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `OMNIVORE`
--
ALTER TABLE `OMNIVORE`
  ADD CONSTRAINT `fk_omnivore_species` FOREIGN KEY (`SPECIES_ID`) REFERENCES `SPECIES` (`SPECIES_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `RELEASE`
--
ALTER TABLE `RELEASE`
  ADD CONSTRAINT `fk_release_animal` FOREIGN KEY (`ANIMAL_ID`) REFERENCES `ANIMAL` (`ANIMAL_ID`);

--
-- Constraints for table `STAFF`
--
ALTER TABLE `STAFF`
  ADD CONSTRAINT `fk_staff_facility` FOREIGN KEY (`FACILITY_ID`) REFERENCES `FACILITY` (`FACILITY_ID`);

--
-- Constraints for table `TREATMENT`
--
ALTER TABLE `TREATMENT`
  ADD CONSTRAINT `fk_treatment_animal` FOREIGN KEY (`ANIMAL_ID`) REFERENCES `ANIMAL` (`ANIMAL_ID`),
  ADD CONSTRAINT `fk_treatment_responder` FOREIGN KEY (`RESPONDER_ID`) REFERENCES `RESPONDER` (`RESPONDER_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
