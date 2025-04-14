-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2025 at 12:14 PM
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
-- Database: `absensi`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_user` (IN `p_nama` VARCHAR(100), IN `p_email` VARCHAR(100), IN `p_password` VARCHAR(100), IN `p_prodi` VARCHAR(100), IN `p_role` VARCHAR(50), IN `p_status_keaktifan` VARCHAR(20), IN `p_id_kelas` INT)   BEGIN
    INSERT INTO user (nama, email, password, prodi, role, status_keaktifan, id_kelas)
    VALUES (p_nama, p_email, p_password, p_prodi, p_role, p_status_keaktifan, p_id_kelas);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `jumlah_absensi` (`user_id` INT) RETURNS INT(11)  BEGIN
    DECLARE jumlah_absensi INT;

    SELECT COUNT(*) INTO jumlah_absensi
    FROM kehadiran
    WHERE id_user = user_id;

    RETURN jumlah_absensi;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `jumlah_cuti` (`user_id` INT) RETURNS INT(11)  BEGIN
    DECLARE jumlah_cuti INT;

    SELECT COUNT(*) INTO jumlah_cuti
    FROM cuti
    WHERE id_user = user_id;

    RETURN jumlah_cuti;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cuti`
--

CREATE TABLE `cuti` (
  `id_cuti` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `alasan` text NOT NULL,
  `status` enum('Disetujui','Ditolak','Menunggu') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cuti`
--

INSERT INTO `cuti` (`id_cuti`, `id_user`, `tanggal_mulai`, `tanggal_selesai`, `alasan`, `status`) VALUES
(1, 1, '2025-04-15', '2025-04-17', 'Liburan keluarga', 'Disetujui'),
(2, 2, '2025-04-10', '2025-04-12', 'Perawatan medis', 'Menunggu'),
(3, 3, '2025-04-20', '2025-04-22', 'Acara pernikahan', 'Ditolak'),
(4, 4, '2025-04-25', '2025-04-28', 'Liburan panjang', 'Disetujui'),
(5, 5, '2025-04-30', '2025-05-02', 'Keluarga sakit', 'Menunggu'),
(6, 6, '2025-05-05', '2025-05-07', 'Perjalanan dinas', 'Ditolak'),
(7, 7, '2025-05-10', '2025-05-12', 'Kegiatan sosial', 'Disetujui'),
(8, 8, '2025-05-15', '2025-05-17', 'Rehat sejenak', 'Menunggu'),
(9, 9, '2025-05-20', '2025-05-22', 'Pengurusan dokumen', 'Disetujui'),
(10, 10, '2025-05-25', '2025-05-27', 'Acara keluarga', 'Ditolak'),
(100, 1, '2025-05-01', '2025-05-03', 'Pulang kampung', 'Disetujui'),
(101, 1, '2025-05-01', '2025-05-03', 'pulang kampung', 'Disetujui');

--
-- Triggers `cuti`
--
DELIMITER $$
CREATE TRIGGER `before_insert_cuti` BEFORE INSERT ON `cuti` FOR EACH ROW BEGIN
    IF NEW.status IS NULL THEN
        SET NEW.status = 'Menunggu';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `izin`
--

CREATE TABLE `izin` (
  `id_izin` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `alasan` enum('sakit','cuti','lainnya') NOT NULL,
  `status` enum('Disetujui','Ditolak','Menunggu') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `izin`
--

INSERT INTO `izin` (`id_izin`, `id_user`, `tanggal`, `alasan`, `status`) VALUES
(1, 1, '2025-04-15', 'sakit', 'Menunggu'),
(2, 2, '2025-04-15', 'cuti', 'Disetujui'),
(3, 3, '2025-04-15', 'lainnya', 'Ditolak'),
(4, 4, '2025-04-16', 'sakit', 'Disetujui'),
(5, 5, '2025-04-16', 'cuti', 'Menunggu'),
(6, 6, '2025-04-16', 'lainnya', 'Menunggu'),
(7, 7, '2025-04-17', 'sakit', 'Ditolak'),
(8, 8, '2025-04-17', 'cuti', 'Disetujui'),
(9, 9, '2025-04-17', 'lainnya', 'Menunggu'),
(10, 10, '2025-04-17', 'sakit', 'Disetujui');

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_kelas`
--

CREATE TABLE `jadwal_kelas` (
  `id_jadwal` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `hari` varchar(50) NOT NULL,
  `jam_masuk` time NOT NULL,
  `jam_keluar` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jadwal_kelas`
--

INSERT INTO `jadwal_kelas` (`id_jadwal`, `id_user`, `hari`, `jam_masuk`, `jam_keluar`) VALUES
(1, 1, 'Senin', '08:00:00', '10:00:00'),
(2, 2, 'Senin', '10:30:00', '12:30:00'),
(3, 3, 'Selasa', '08:00:00', '10:00:00'),
(4, 4, 'Selasa', '10:30:00', '12:30:00'),
(5, 5, 'Rabu', '08:00:00', '10:00:00'),
(6, 6, 'Rabu', '10:30:00', '12:30:00'),
(7, 7, 'Kamis', '08:00:00', '10:00:00'),
(8, 8, 'Kamis', '10:30:00', '12:30:00'),
(9, 9, 'Jumat', '08:00:00', '10:00:00'),
(10, 10, 'Jumat', '10:30:00', '12:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `kehadiran`
--

CREATE TABLE `kehadiran` (
  `id_absen` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `waktu_masuk` time NOT NULL,
  `waktu_keluar` time DEFAULT NULL,
  `status` enum('Hadir','Terlambat','Izin','Alpha') NOT NULL,
  `id_jadwal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kehadiran`
--

INSERT INTO `kehadiran` (`id_absen`, `id_user`, `tanggal`, `waktu_masuk`, `waktu_keluar`, `status`, `id_jadwal`) VALUES
(1, 1, '2025-04-15', '08:00:00', '16:00:00', 'Hadir', 1),
(2, 2, '2025-04-15', '08:15:00', '16:00:00', 'Terlambat', 2),
(3, 3, '2025-04-15', '08:00:00', '16:00:00', 'Hadir', 3),
(4, 4, '2025-04-16', '09:00:00', '17:00:00', 'Hadir', 2),
(5, 5, '2025-04-16', '08:05:00', '16:00:00', 'Terlambat', 1),
(6, 6, '2025-04-16', '08:00:00', '15:30:00', 'Izin', 4),
(7, 7, '2025-04-17', '08:00:00', '16:00:00', 'Hadir', 3),
(8, 8, '2025-04-17', '08:10:00', '16:00:00', 'Terlambat', 2),
(9, 9, '2025-04-17', '08:00:00', '16:00:00', 'Izin', 1),
(10, 10, '2025-04-17', '08:00:00', '16:00:00', 'Hadir', 4);

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `id_kelas` int(11) NOT NULL,
  `nama_kelas` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`id_kelas`, `nama_kelas`) VALUES
(1, 'Kelas A'),
(2, 'Kelas B'),
(3, 'Kelas C'),
(4, 'Kelas D');

-- --------------------------------------------------------

--
-- Table structure for table `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `id_mk` int(11) NOT NULL,
  `kode_mk` varchar(50) NOT NULL,
  `nama_mk` varchar(50) NOT NULL,
  `sks` varchar(50) NOT NULL,
  `semester` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`id_mk`, `kode_mk`, `nama_mk`, `sks`, `semester`) VALUES
(1, 'IF101', 'Algoritma dan Pemrograman', '3', 'Gasal'),
(2, 'IF102', 'Struktur Data', '3', 'Gasal'),
(3, 'IF103', 'Basis Data', '3', 'Genap'),
(4, 'IF104', 'Jaringan Komputer', '2', 'Genap'),
(5, 'IF105', 'Sistem Operasi', '3', 'Gasal'),
(6, 'IF106', 'Pemrograman Web', '3', 'Genap'),
(7, 'IF107', 'Kecerdasan Buatan', '3', 'Gasal'),
(8, 'IF108', 'Keamanan Sistem', '2', 'Genap'),
(9, 'IF109', 'Pemrograman Mobile', '3', 'Gasal'),
(10, 'IF110', 'Rekayasa Perangkat Lunak', '3', 'Genap');

-- --------------------------------------------------------

--
-- Table structure for table `pengampu`
--

CREATE TABLE `pengampu` (
  `id_pengampu` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `id_mk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengampu`
--

INSERT INTO `pengampu` (`id_pengampu`, `id_user`, `id_kelas`, `id_mk`) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 4, 4),
(5, 5, 1, 5),
(6, 6, 2, 6),
(7, 7, 3, 7),
(8, 8, 4, 8),
(9, 9, 1, 9),
(10, 10, 2, 10);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `prodi` varchar(100) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `status_keaktifan` enum('aktif','tidak aktif') DEFAULT NULL,
  `id_kelas` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama`, `email`, `password`, `prodi`, `role`, `status_keaktifan`, `id_kelas`) VALUES
(1, 'Andi Setiawan', 'andi@example.com', 'password123', 'Informatika', 'mahasiswa', 'aktif', 1),
(2, 'Budi Santoso', 'budi@example.com', 'password123', 'Informatika', 'mahasiswa', 'aktif', 2),
(3, 'Citra Amelia', 'citra@example.com', 'password123', 'Sistem Informasi', 'mahasiswa', 'tidak aktif', 3),
(4, 'Dina Pratiwi', 'dina@example.com', 'password123', 'Sistem Informasi', 'mahasiswa', 'aktif', 2),
(5, 'Eko Wijaya', 'eko@example.com', 'password123', 'Sistem Informasi Akuntansi', 'mahasiswa', 'aktif', 1),
(6, 'Fani Rahmawati', 'fani@example.com', 'password123', 'Informatika', 'mahasiswa', 'tidak aktif', 4),
(7, 'Gina Melinda', 'gina@example.com', 'password123', 'Sistem Informasi Akuntansi', 'mahasiswa', 'aktif', 3),
(8, 'Hadiyanto', 'hadi@example.com', 'password123', 'Informatika', 'mahasiswa', 'aktif', 4),
(9, 'Indra Wijaya', 'indra@example.com', 'password123', 'Sistem Informasi', 'mahasiswa', 'aktif', 2),
(10, 'Joko Sutrisno', 'joko@example.com', 'password123', 'Informatika', 'mahasiswa', 'aktif', 1),
(12, 'Ema', 'ema@gmail.com', 'ema123', 'informatika', 'mahasiswa', 'aktif', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_izin_cuti`
-- (See below for the actual view)
--
CREATE TABLE `view_izin_cuti` (
`id` int(11)
,`nama` varchar(200)
,`mulai` date
,`selesai` date
,`alasan` mediumtext
,`status` varchar(9)
,`jenis` varchar(4)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_rekap_kehadiran`
-- (See below for the actual view)
--
CREATE TABLE `view_rekap_kehadiran` (
`id_absen` int(11)
,`nama_user` varchar(200)
,`tanggal` date
,`waktu_masuk` time
,`waktu_keluar` time
,`status` enum('Hadir','Terlambat','Izin','Alpha')
);

-- --------------------------------------------------------

--
-- Structure for view `view_izin_cuti`
--
DROP TABLE IF EXISTS `view_izin_cuti`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_izin_cuti`  AS SELECT `i`.`id_izin` AS `id`, `u`.`nama` AS `nama`, `i`.`tanggal` AS `mulai`, `i`.`tanggal` AS `selesai`, `i`.`alasan` AS `alasan`, `i`.`status` AS `status`, 'izin' AS `jenis` FROM (`izin` `i` join `user` `u` on(`i`.`id_user` = `u`.`id_user`))union select `c`.`id_cuti` AS `id`,`u`.`nama` AS `nama`,`c`.`tanggal_mulai` AS `tanggal_mulai`,`c`.`tanggal_selesai` AS `tanggal_selesai`,`c`.`alasan` AS `alasan`,`c`.`status` AS `status`,'cuti' AS `jenis` from (`cuti` `c` join `user` `u` on(`c`.`id_user` = `u`.`id_user`))  ;

-- --------------------------------------------------------

--
-- Structure for view `view_rekap_kehadiran`
--
DROP TABLE IF EXISTS `view_rekap_kehadiran`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_rekap_kehadiran`  AS SELECT `k`.`id_absen` AS `id_absen`, `u`.`nama` AS `nama_user`, `k`.`tanggal` AS `tanggal`, `k`.`waktu_masuk` AS `waktu_masuk`, `k`.`waktu_keluar` AS `waktu_keluar`, `k`.`status` AS `status` FROM (`kehadiran` `k` join `user` `u` on(`k`.`id_user` = `u`.`id_user`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cuti`
--
ALTER TABLE `cuti`
  ADD PRIMARY KEY (`id_cuti`),
  ADD KEY `fk_cuti` (`id_user`);

--
-- Indexes for table `izin`
--
ALTER TABLE `izin`
  ADD PRIMARY KEY (`id_izin`),
  ADD KEY `fk_izin` (`id_user`);

--
-- Indexes for table `jadwal_kelas`
--
ALTER TABLE `jadwal_kelas`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD KEY `idx_id_user` (`id_user`);

--
-- Indexes for table `kehadiran`
--
ALTER TABLE `kehadiran`
  ADD PRIMARY KEY (`id_absen`),
  ADD KEY `fk_kehadiran_jadwal` (`id_user`),
  ADD KEY `id_jadwal` (`id_jadwal`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id_kelas`);

--
-- Indexes for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD PRIMARY KEY (`id_mk`);

--
-- Indexes for table `pengampu`
--
ALTER TABLE `pengampu`
  ADD PRIMARY KEY (`id_pengampu`),
  ADD KEY `fk_pengampu` (`id_user`),
  ADD KEY `id_kelas` (`id_kelas`),
  ADD KEY `id_mk` (`id_mk`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `fk_user_kelas` (`id_kelas`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cuti`
--
ALTER TABLE `cuti`
  MODIFY `id_cuti` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  MODIFY `id_mk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cuti`
--
ALTER TABLE `cuti`
  ADD CONSTRAINT `fk_cuti` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `izin`
--
ALTER TABLE `izin`
  ADD CONSTRAINT `fk_izin` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `jadwal_kelas`
--
ALTER TABLE `jadwal_kelas`
  ADD CONSTRAINT `fk_jadwal_user` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `kehadiran`
--
ALTER TABLE `kehadiran`
  ADD CONSTRAINT `fk_kehadiran_jadwal` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `id_jadwal` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_kelas` (`id_jadwal`);

--
-- Constraints for table `pengampu`
--
ALTER TABLE `pengampu`
  ADD CONSTRAINT `fk_pengampu` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `id_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`),
  ADD CONSTRAINT `id_mk` FOREIGN KEY (`id_mk`) REFERENCES `mata_kuliah` (`id_mk`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `fk_user_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
