-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 08, 2026 at 12:46 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ukk_sipinjam`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pengembalian` (IN `p_id_peminjaman` INT, IN `p_tanggal_kembali` DATE)   BEGIN
    INSERT INTO tb_pengembalian (id_peminjaman,tanggal_kembali)
    VALUES (p_id_peminjaman,p_tanggal_kembali);

    UPDATE tb_peminjaman
    SET status='dikembalikan'
    WHERE id_peminjaman=p_id_peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_detail` (IN `p_id_peminjaman` INT, IN `p_id_alat` INT, IN `p_jumlah` INT)   BEGIN
    INSERT INTO tb_detail_peminjaman (id_peminjaman,id_alat,jumlah)
    VALUES (p_id_peminjaman,p_id_alat,p_jumlah);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_peminjaman` (IN `p_id_user` INT, IN `p_tanggal_pinjam` DATE, IN `p_tanggal_kembali` DATE)   BEGIN
    INSERT INTO tb_peminjaman (id_user,tanggal_pinjam,tanggal_kembali,status)
    VALUES (p_id_user,p_tanggal_pinjam,p_tanggal_kembali,'menunggu');
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_alat`
--

CREATE TABLE `tb_alat` (
  `id_alat` int(11) NOT NULL,
  `nama_alat` varchar(100) DEFAULT NULL,
  `id_kategori` int(11) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_alat`
--

INSERT INTO `tb_alat` (`id_alat`, `nama_alat`, `id_kategori`, `stok`) VALUES
(1, 'Laptop ASUS', 1, 5),
(2, 'Laptop Lenovo', 1, 4),
(3, 'Laptop Acer', 1, 3),
(4, 'Proyektor Epson', 2, 2),
(5, 'Proyektor Panasonic', 2, 1),
(6, 'Kamera Canon', 2, 3),
(7, 'Tripod Kamera', 3, 2),
(8, 'Speaker Bluetooth', 2, 4),
(9, 'Mouse Wireless', 3, 6),
(10, 'Keyboard Mechanical', 3, 5);

-- --------------------------------------------------------

--
-- Table structure for table `tb_detail_peminjaman`
--

CREATE TABLE `tb_detail_peminjaman` (
  `id_detail` int(11) NOT NULL,
  `id_peminjaman` int(11) DEFAULT NULL,
  `id_alat` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_detail_peminjaman`
--

INSERT INTO `tb_detail_peminjaman` (`id_detail`, `id_peminjaman`, `id_alat`, `jumlah`) VALUES
(1, 1, 1, 2),
(2, 1, 4, 1),
(3, 2, 2, 1);

--
-- Triggers `tb_detail_peminjaman`
--
DELIMITER $$
CREATE TRIGGER `trg_kurangi_stok` AFTER INSERT ON `tb_detail_peminjaman` FOR EACH ROW BEGIN
    UPDATE tb_alat
    SET stok = stok - NEW.jumlah
    WHERE id_alat = NEW.id_alat;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_kategori`
--

CREATE TABLE `tb_kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_kategori`
--

INSERT INTO `tb_kategori` (`id_kategori`, `nama_kategori`) VALUES
(1, 'Elektronik'),
(2, 'Multimedia'),
(3, 'Aksesoris');

-- --------------------------------------------------------

--
-- Table structure for table `tb_log`
--

CREATE TABLE `tb_log` (
  `id_log` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `aktivitas` text DEFAULT NULL,
  `waktu` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_log`
--

INSERT INTO `tb_log` (`id_log`, `id_user`, `aktivitas`, `waktu`) VALUES
(1, 1, 'Login ke sistem', '2026-04-08 06:46:44'),
(2, 2, 'Menyetujui peminjaman', '2026-04-08 06:46:44');

-- --------------------------------------------------------

--
-- Table structure for table `tb_peminjaman`
--

CREATE TABLE `tb_peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `status` enum('menunggu','disetujui','ditolak','dikembalikan','terlambat') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_peminjaman`
--

INSERT INTO `tb_peminjaman` (`id_peminjaman`, `id_user`, `tanggal_pinjam`, `tanggal_kembali`, `status`) VALUES
(1, 3, '2025-05-01', '2025-05-05', 'menunggu'),
(2, 4, '2025-05-02', '2025-05-06', 'disetujui');

--
-- Triggers `tb_peminjaman`
--
DELIMITER $$
CREATE TRIGGER `trg_log_pinjam` AFTER INSERT ON `tb_peminjaman` FOR EACH ROW BEGIN
    INSERT INTO tb_log (id_user,aktivitas)
    VALUES (NEW.id_user, CONCAT('Menambah peminjaman ID ', NEW.id_peminjaman));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_pengembalian`
--

CREATE TABLE `tb_pengembalian` (
  `id_pengembalian` int(11) NOT NULL,
  `id_peminjaman` int(11) DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `denda` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_pengembalian`
--

INSERT INTO `tb_pengembalian` (`id_pengembalian`, `id_peminjaman`, `tanggal_kembali`, `denda`) VALUES
(1, 2, '2025-05-06', 0);

--
-- Triggers `tb_pengembalian`
--
DELIMITER $$
CREATE TRIGGER `trg_denda` BEFORE INSERT ON `tb_pengembalian` FOR EACH ROW BEGIN
    DECLARE telat INT;

    SELECT DATEDIFF(NEW.tanggal_kembali, p.tanggal_kembali)
    INTO telat
    FROM tb_peminjaman p
    WHERE p.id_peminjaman = NEW.id_peminjaman;

    IF telat > 0 THEN
        SET NEW.denda = telat * 5000;
    ELSE
        SET NEW.denda = 0;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_kembalikan_stok` AFTER INSERT ON `tb_pengembalian` FOR EACH ROW BEGIN
    UPDATE tb_alat a
    JOIN tb_detail_peminjaman d ON a.id_alat = d.id_alat
    SET a.stok = a.stok + d.jumlah
    WHERE d.id_peminjaman = NEW.id_peminjaman;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_log_kembali` AFTER INSERT ON `tb_pengembalian` FOR EACH ROW BEGIN
    INSERT INTO tb_log (id_user,aktivitas)
    SELECT p.id_user, CONCAT('Mengembalikan peminjaman ID ', NEW.id_peminjaman)
    FROM tb_peminjaman p
    WHERE p.id_peminjaman = NEW.id_peminjaman;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_user`
--

CREATE TABLE `tb_user` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `role` enum('admin','petugas','peminjam') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_user`
--

INSERT INTO `tb_user` (`id_user`, `username`, `password`, `nama`, `role`) VALUES
(1, 'admin', '123', 'Administrator', 'admin'),
(2, 'petugas', '123', 'Petugas', 'petugas'),
(3, 'user1', '123', 'Budi', 'peminjam'),
(4, 'shinta', '123', 'shinta', 'peminjam');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_alat`
--
ALTER TABLE `tb_alat`
  ADD PRIMARY KEY (`id_alat`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `tb_detail_peminjaman`
--
ALTER TABLE `tb_detail_peminjaman`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_peminjaman` (`id_peminjaman`),
  ADD KEY `id_alat` (`id_alat`);

--
-- Indexes for table `tb_kategori`
--
ALTER TABLE `tb_kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `tb_log`
--
ALTER TABLE `tb_log`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `tb_peminjaman`
--
ALTER TABLE `tb_peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `tb_pengembalian`
--
ALTER TABLE `tb_pengembalian`
  ADD PRIMARY KEY (`id_pengembalian`),
  ADD KEY `id_peminjaman` (`id_peminjaman`);

--
-- Indexes for table `tb_user`
--
ALTER TABLE `tb_user`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_alat`
--
ALTER TABLE `tb_alat`
  MODIFY `id_alat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tb_detail_peminjaman`
--
ALTER TABLE `tb_detail_peminjaman`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tb_kategori`
--
ALTER TABLE `tb_kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tb_log`
--
ALTER TABLE `tb_log`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tb_peminjaman`
--
ALTER TABLE `tb_peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tb_pengembalian`
--
ALTER TABLE `tb_pengembalian`
  MODIFY `id_pengembalian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tb_user`
--
ALTER TABLE `tb_user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_alat`
--
ALTER TABLE `tb_alat`
  ADD CONSTRAINT `tb_alat_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `tb_kategori` (`id_kategori`);

--
-- Constraints for table `tb_detail_peminjaman`
--
ALTER TABLE `tb_detail_peminjaman`
  ADD CONSTRAINT `tb_detail_peminjaman_ibfk_1` FOREIGN KEY (`id_peminjaman`) REFERENCES `tb_peminjaman` (`id_peminjaman`),
  ADD CONSTRAINT `tb_detail_peminjaman_ibfk_2` FOREIGN KEY (`id_alat`) REFERENCES `tb_alat` (`id_alat`);

--
-- Constraints for table `tb_log`
--
ALTER TABLE `tb_log`
  ADD CONSTRAINT `tb_log_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tb_user` (`id_user`) ON DELETE SET NULL;

--
-- Constraints for table `tb_peminjaman`
--
ALTER TABLE `tb_peminjaman`
  ADD CONSTRAINT `tb_peminjaman_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tb_user` (`id_user`);

--
-- Constraints for table `tb_pengembalian`
--
ALTER TABLE `tb_pengembalian`
  ADD CONSTRAINT `tb_pengembalian_ibfk_1` FOREIGN KEY (`id_peminjaman`) REFERENCES `tb_peminjaman` (`id_peminjaman`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
