From: Christoph Hellwig <hch@lst.de>
Subject: ]PATCH] two new device list entries
Date: Thu, 20 Feb 2003 20:42:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030220204244.B19476@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

The NEC one is from the PC98 folks, the Sun one from feral's isp driver


--- 1.59/drivers/scsi/scsi_scan.c	Tue Feb 11 10:56:25 2003
+++ edited/drivers/scsi/scsi_scan.c	Thu Feb 20 18:02:11 2003
@@ -84,6 +84,7 @@
 	{"NEC", "CD-ROM DRIVE:841", "1.0", BLIST_NOLUN},/* locks up */
 	{"PHILIPS", "PCA80SC", "V4-2", BLIST_NOLUN},	/* responds to all lun */
 	{"RODIME", "RO3000S", "2.33", BLIST_NOLUN},	/* locks up */
+	{"SUN", "SENA", NULL, BLIST_NOLUN},		/* responds to all luns */
 	/*
 	 * The following causes a failed REQUEST SENSE on lun 1 for
 	 * aha152x controller, which causes SCSI code to reset bus.
@@ -128,6 +129,7 @@
 	{"MITSUMI", "CD-R CR-2201CS", "6119", BLIST_NOLUN},	/* locks up */
 	{"RELISYS", "Scorpio", NULL, BLIST_NOLUN},	/* responds to all lun */
 	{"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN},	/* responds to all lun */
+	{"NEC", "D3856", "0009", BLIST_NOLUN},
 
 	/*
 	 * Other types of devices that have special flags.
