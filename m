From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 2.5.59 add two help texts to drivers_scsi_Kconfig
Date: Thu, 06 Feb 2003 16:55:09 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206055746.DF1D42C13E@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, linux-scsi@vger.kernel.org

From:  Steven Cole <elenstev@mesatop.com>

  Here are some help texts from 2.4.21-pre3 Configure.help which are
  needed in 2.5.59 drivers/scsi/Kconfig.
  
  Steven
  

--- trivial-2.5-bk/drivers/scsi/Kconfig.orig	2003-02-06 16:30:22.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/Kconfig	2003-02-06 16:30:22.000000000 +1100
@@ -176,6 +176,9 @@
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
 	depends on SGI_IP22 && SCSI
+  	help
+	  If you have a Western Digital WD93 SCSI controller on
+	  an SGI MIPS system, say Y.  Otherwise, say N.
 
 config SCSI_DECNCR
 	tristate "DEC NCR53C94 Scsi Driver"
@@ -1342,6 +1345,10 @@
 config SCSI_QLOGIC_FC_FIRMWARE
 	bool "Include loadable firmware in driver"
 	depends on SCSI_QLOGIC_FC
+  	help
+	  Say Y to include ISP2100 Fabric Initiator/Target Firmware, with
+	  expanded LUN addressing and FcTape (FCP-2) support, in the
+	  Qlogic QLA 1280 driver. This is required on some platforms.
 
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1280 SCSI support"
-- 
  Don't blame me: the Monkey is driving
  File: Steven Cole <elenstev@mesatop.com>: [PATCH] 2.5.59 add two help texts to drivers_scsi_Kconfig
