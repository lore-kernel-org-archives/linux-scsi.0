From: Marc-Christian Petersen <m.c.p@wolk-project.de>
Subject: [PATCH 2.6.4-rc2] Reorder SCSI_GENERIC_NCR53C400 Kconfig entry
Date: Sun, 7 Mar 2004 21:56:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403072156.32564@WOLK>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Ay4SA+kMUjGGILL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lindsey.linux-systeme.com ([62.241.33.80]:49926 "EHLO
	mx00.linux-systeme.com") by vger.kernel.org with ESMTP
	id S262341AbUCGV5J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Mar 2004 16:57:09 -0500
Received: from p5087d162.dip.t-dialin.net (p5087D162.dip.t-dialin.net [80.135.209.98])
	(authenticated bits=0)
	by mx00.linux-systeme.com (8.12.11/8.12.11/Debian-3) with ESMTP id i27Lv1oB024436
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 7 Mar 2004 22:57:06 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--Boundary-00=_Ay4SA+kMUjGGILL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there,

SCSI_GENERIC_NCR53C400 should be under SCSI_GENERIC_NCR5380 in 
drivers/scsi/Kconfig

ciao, Marc

--Boundary-00=_Ay4SA+kMUjGGILL
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="Kconfig-cleanup-scsi-wrong-order.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Kconfig-cleanup-scsi-wrong-order.patch"

--- old/drivers/scsi/Kconfig	2004-03-07 15:53:35.000000000 +0100
+++ new/drivers/scsi/Kconfig	2004-03-07 16:01:24.000000000 +0100
@@ -643,6 +643,17 @@ config SCSI_GENERIC_NCR5380
 	  To compile this driver as a module, choose M here: the
 	  module will be called g_NCR5380.
 
+config SCSI_GENERIC_NCR53C400
+	bool "Enable NCR53c400 extensions"
+	depends on SCSI_GENERIC_NCR5380
+	help
+	  This enables certain optimizations for the NCR53c400 SCSI cards.
+	  You might as well try it out.  Note that this driver will only probe
+	  for the Trantor T130B in its default configuration; you might have
+	  to pass a command line option to the kernel at boot time if it does
+	  not detect your card.  See the file
+	  <file:Documentation/scsi/g_NCR5380.txt> for details.
+
 config SCSI_GENERIC_NCR5380_MMIO
 	tristate "Generic NCR5380/53c400 SCSI MMIO support"
 	depends on ISA && SCSI
@@ -657,17 +668,6 @@ config SCSI_GENERIC_NCR5380_MMIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called g_NCR5380_mmio.
 
-config SCSI_GENERIC_NCR53C400
-	bool "Enable NCR53c400 extensions"
-	depends on SCSI_GENERIC_NCR5380
-	help
-	  This enables certain optimizations for the NCR53c400 SCSI cards.
-	  You might as well try it out.  Note that this driver will only probe
-	  for the Trantor T130B in its default configuration; you might have
-	  to pass a command line option to the kernel at boot time if it does
-	  not detect your card.  See the file
-	  <file:Documentation/scsi/g_NCR5380.txt> for details.
-
 config SCSI_IBMMCA
 	tristate "IBMMCA SCSI support"
 	depends on MCA && SCSI

--Boundary-00=_Ay4SA+kMUjGGILL--

