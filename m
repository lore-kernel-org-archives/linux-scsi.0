From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/qla2xxx/Kconfig: two fixes
Date: Fri, 6 Jan 2006 17:34:01 +0100
Message-ID: <20060106163401.GP12131@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57355 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1752447AbWAFQeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 11:34:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch contains the following fixes for 
drivers/scsi/qla2xxx/Kconfig:
- add a help text for SCSI_QLA2XXX_EMBEDDED_FIRMWARE
- the firmware modules must depend on SCSI_QLA2XXX to prevent
  illegal configurations like SCSI_QLA2XXX=m, SCSI_QLA21XX=y


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/qla2xxx/Kconfig |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- linux-2.6.15-mm1-full/drivers/scsi/qla2xxx/Kconfig.old	2006-01-06 16:38:09.000000000 +0100
+++ linux-2.6.15-mm1-full/drivers/scsi/qla2xxx/Kconfig	2006-01-06 16:39:51.000000000 +0100
@@ -29,42 +29,46 @@
 config SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	bool "  Use firmware-loader modules (DEPRECATED)"
 	depends on SCSI_QLA2XXX
+	help
+	  This option offers you the deprecated firmware-loader
+	  modules that have been obsoleted by the usage of the
+	  Firmware Loader interface in the qla2xxx driver.
 
 config SCSI_QLA21XX
 	tristate "  Build QLogic ISP2100 firmware-module"
-	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+	depends on SCSI_QLA2XXX && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
 	This driver supports the QLogic 21xx (ISP2100) host adapter family.
 
 config SCSI_QLA22XX
 	tristate "  Build QLogic ISP2200 firmware-module"
-	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+	depends on SCSI_QLA2XXX && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
 	This driver supports the QLogic 22xx (ISP2200) host adapter family.
 
 config SCSI_QLA2300
 	tristate "  Build QLogic ISP2300 firmware-module"
-	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+	depends on SCSI_QLA2XXX && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
 	This driver supports the QLogic 2300 (ISP2300 and ISP2312) host
 	adapter family.
 
 config SCSI_QLA2322
 	tristate "  Build QLogic ISP2322 firmware-module"
-	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+	depends on SCSI_QLA2XXX && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
 	This driver supports the QLogic 2322 (ISP2322) host adapter family.
 
 config SCSI_QLA6312
 	tristate "  Build QLogic ISP63xx firmware-module"
-	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+	depends on SCSI_QLA2XXX && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
 	This driver supports the QLogic 63xx (ISP6312 and ISP6322) host
 	adapter family.
 
 config SCSI_QLA24XX
 	tristate "  Build QLogic ISP24xx firmware-module"
-	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+	depends on SCSI_QLA2XXX && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
 	This driver supports the QLogic 24xx (ISP2422 and ISP2432) host
 	adapter family.

