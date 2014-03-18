From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 02/12] scsi/NCR5380: remove redundant HOSTS_C macro tests
Date: Tue, 18 Mar 2014 11:42:14 +1100
Message-ID: <20140318004213.222484138@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-HOSTS_C-macro
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

HOSTS_C is always undefined. There is no hosts.c anymore.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/g_NCR5380.h |    3 ---
 drivers/scsi/mac_scsi.h  |    3 ---
 drivers/scsi/pas16.h     |    3 ---
 drivers/scsi/sun3_scsi.h |    3 ---
 drivers/scsi/t128.h      |    3 ---
 5 files changed, 15 deletions(-)

Index: linux-m68k/drivers/scsi/g_NCR5380.h
===================================================================
--- linux-m68k.orig/drivers/scsi/g_NCR5380.h	2014-03-17 23:49:30.000000000 +1100
+++ linux-m68k/drivers/scsi/g_NCR5380.h	2014-03-18 00:18:30.000000000 +1100
@@ -58,8 +58,6 @@ static const char* generic_NCR5380_info(
 #define CAN_QUEUE 16
 #endif
 
-#ifndef HOSTS_C
-
 #define __STRVAL(x) #x
 #define STRVAL(x) __STRVAL(x)
 
@@ -131,7 +129,6 @@ static const char* generic_NCR5380_info(
 #define BOARD_NCR53C400A 2
 #define BOARD_DTC3181E	3
 
-#endif /* else def HOSTS_C */
 #endif /* ndef ASM */
 #endif /* GENERIC_NCR5380_H */
 
Index: linux-m68k/drivers/scsi/mac_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.h	2014-03-18 00:18:20.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.h	2014-03-18 00:18:30.000000000 +1100
@@ -51,8 +51,6 @@
 
 #include <scsi/scsicam.h>
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     int port, ctrl
 
@@ -75,7 +73,6 @@
 #define NCR5380_show_info macscsi_show_info
 #define NCR5380_write_info macscsi_write_info
 
-#endif /* ndef HOSTS_C */
 #endif /* ndef ASM */
 #endif /* MAC_NCR5380_H */
 
Index: linux-m68k/drivers/scsi/pas16.h
===================================================================
--- linux-m68k.orig/drivers/scsi/pas16.h	2014-03-17 23:49:30.000000000 +1100
+++ linux-m68k/drivers/scsi/pas16.h	2014-03-18 00:18:30.000000000 +1100
@@ -129,8 +129,6 @@ static int pas16_bus_reset(Scsi_Cmnd *);
 #define CAN_QUEUE 32 
 #endif
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     volatile unsigned short io_port
 
@@ -171,6 +169,5 @@ static int pas16_bus_reset(Scsi_Cmnd *);
    
 #define PAS16_IRQS 0xd4a8 
 
-#endif /* else def HOSTS_C */
 #endif /* ndef ASM */
 #endif /* PAS16_H */
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:20.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:30.000000000 +1100
@@ -82,8 +82,6 @@ static int sun3scsi_release (struct Scsi
 #define SUN3_SCSI_NAME "Sun3 NCR5380 SCSI"
 #endif
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     int port, ctrl
 
@@ -371,6 +369,5 @@ struct sun3_udc_regs {
 
 
 
-#endif /* ndef HOSTS_C */
 #endif /* SUN3_NCR5380_H */
 
Index: linux-m68k/drivers/scsi/t128.h
===================================================================
--- linux-m68k.orig/drivers/scsi/t128.h	2014-03-17 23:49:30.000000000 +1100
+++ linux-m68k/drivers/scsi/t128.h	2014-03-18 00:18:30.000000000 +1100
@@ -107,8 +107,6 @@ static int t128_bus_reset(struct scsi_cm
 #define CAN_QUEUE 32
 #endif
 
-#ifndef HOSTS_C
-
 #define NCR5380_implementation_fields \
     void __iomem *base
 
@@ -148,6 +146,5 @@ static int t128_bus_reset(struct scsi_cm
 
 #define T128_IRQS 0xc4a8
 
-#endif /* else def HOSTS_C */
 #endif /* ndef ASM */
 #endif /* T128_H */
