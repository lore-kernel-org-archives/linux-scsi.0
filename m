From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] scsi: kconfig: When possible, compile drivers with COMPILE_TEST
Date: Wed, 14 Oct 2015 22:13:40 +0100
Message-ID: <1444857220-26595-1-git-send-email-luisbg@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, Luis de Bethencourt <luisbg@osg.samsung.com>
List-Id: linux-scsi@vger.kernel.org

These drivers only have runtime but no build time dependencies, so they can
be built for testing purposes if the Kconfig COMPILE_TEST option is enabled.

This is useful to have more build coverage and make sure that drivers are
not affected by changes that could cause build regressions.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 drivers/scsi/Kconfig | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d2f480b..0d8ee16 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -416,7 +416,7 @@ config SCSI_ACARD
 
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	select SCSI_SPI_ATTRS
 	select CHECK_SIGNATURE
 	---help---
@@ -509,7 +509,7 @@ config SCSI_ADVANSYS
 
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	help
 	  This is support for an ISA bus SCSI host adapter.  You'll find more
 	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
@@ -657,7 +657,7 @@ config SCSI_DMX3191D
 
 config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	select SCSI_SPI_ATTRS
 	select CHECK_SIGNATURE
 	help
@@ -776,7 +776,7 @@ config SCSI_ISCI
 
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
@@ -796,7 +796,7 @@ config SCSI_GENERIC_NCR5380
 
 config SCSI_GENERIC_NCR5380_MMIO
 	tristate "Generic NCR5380/53c400 SCSI MMIO support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
@@ -970,7 +970,7 @@ config SCSI_IZIP_SLOW_CTR
 
 config SCSI_NCR53C406A
 	tristate "NCR53c406a SCSI support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	help
 	  This is support for the NCR53c406a SCSI host adapter.  For user
 	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
@@ -1238,7 +1238,7 @@ config SCSI_NCR53C8XX_NO_DISCONNECT
 
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE) && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
@@ -1252,7 +1252,7 @@ config SCSI_PAS16
 
 config SCSI_QLOGIC_FAS
 	tristate "Qlogic FAS SCSI support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	---help---
 	  This is a driver for the ISA, VLB, and PCMCIA versions of the Qlogic
 	  FastSCSI! cards as well as any other card based on the FASXX chip
@@ -1321,7 +1321,7 @@ config SCSI_SIM710
 
 config SCSI_SYM53C416
 	tristate "Symbios 53c416 SCSI support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	---help---
 	  This is support for the sym53c416 SCSI host adapter, the SCSI
 	  adapter that comes with some HP scanners. This driver requires that
@@ -1372,7 +1372,7 @@ config SCSI_AM53C974
 
 config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
-	depends on ISA && SCSI
+	depends on (ISA || COMPILE_TEST) && SCSI
 	select SCSI_SPI_ATTRS
 	select CHECK_SIGNATURE
 	---help---
-- 
2.5.1
