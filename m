From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] let AIC7{9,X}XX_BUILD_FIRMWARE depend on !PREVENT_FIRMWARE_BUILD
Date: Sun, 1 Aug 2004 20:55:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040801185543.GB2746@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:30158 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S266117AbUHASzv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Aug 2004 14:55:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


The patch below lets AIC7{9,X}XX_BUILD_FIRMWARE depend on 
!PREVENT_FIRMWARE_BUILD.


Signed-off-by: Adrian Bunk <bunk@fs.tum.de>

--- linux-2.6.8-rc2-mm1-full/drivers/scsi/aic7xxx/Kconfig.aic7xxx.old	2004-08-01 17:03:52.000000000 +0200
+++ linux-2.6.8-rc2-mm1-full/drivers/scsi/aic7xxx/Kconfig.aic7xxx	2004-08-01 17:04:40.000000000 +0200
@@ -61,7 +61,7 @@
 
 config AIC7XXX_BUILD_FIRMWARE
 	bool "Build Adapter Firmware with Kernel Build"
-	depends on SCSI_AIC7XXX
+	depends on SCSI_AIC7XXX && !PREVENT_FIRMWARE_BUILD
 	help
 	This option should only be enabled if you are modifying the firmware
 	source to the aic7xxx driver and wish to have the generated firmware
--- linux-2.6.8-rc2-mm1-full/drivers/scsi/aic7xxx/Kconfig.aic79xx.old	2004-08-01 17:04:01.000000000 +0200
+++ linux-2.6.8-rc2-mm1-full/drivers/scsi/aic7xxx/Kconfig.aic79xx	2004-08-01 17:04:32.000000000 +0200
@@ -46,7 +46,7 @@
 
 config AIC79XX_BUILD_FIRMWARE
 	bool "Build Adapter Firmware with Kernel Build"
-	depends on SCSI_AIC79XX
+	depends on SCSI_AIC79XX && !PREVENT_FIRMWARE_BUILD
 	help
 	This option should only be enabled if you are modifying the firmware
 	source to the aic79xx driver and wish to have the generated firmware

