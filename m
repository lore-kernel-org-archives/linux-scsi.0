From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 01/12] scsi/NCR5380: remove unused BOARD_NORMAL and BOARD_NCR53C400
Date: Tue, 18 Mar 2014 11:42:13 +1100
Message-ID: <20140318004212.932470722@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-BOARD-macros
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

BOARD_NORMAL is completely unused and BOARD_NCR53C400 is used only by
g_NCR5380 internally. Remove the unused definitions.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/arm/cumana_1.c |    3 ---
 drivers/scsi/arm/oak.c      |    3 ---
 drivers/scsi/mac_scsi.h     |    3 ---
 drivers/scsi/sun3_scsi.h    |    3 ---
 4 files changed, 12 deletions(-)

Index: linux-m68k/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux-m68k.orig/drivers/scsi/arm/cumana_1.c	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/arm/cumana_1.c	2014-03-18 00:18:20.000000000 +1100
@@ -36,9 +36,6 @@
 	void __iomem *base;		\
 	void __iomem *dma
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 #include "../NCR5380.h"
 
 void cumanascsi_setup(char *str, int *ints)
Index: linux-m68k/drivers/scsi/arm/oak.c
===================================================================
--- linux-m68k.orig/drivers/scsi/arm/oak.c	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/arm/oak.c	2014-03-18 00:18:20.000000000 +1100
@@ -37,9 +37,6 @@
 #define NCR5380_implementation_fields	\
 	void __iomem *base
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 #include "../NCR5380.h"
 
 #undef START_DMA_INITIATOR_RECEIVE_REG
Index: linux-m68k/drivers/scsi/mac_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.h	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.h	2014-03-18 00:18:20.000000000 +1100
@@ -75,9 +75,6 @@
 #define NCR5380_show_info macscsi_show_info
 #define NCR5380_write_info macscsi_write_info
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 #endif /* ndef HOSTS_C */
 #endif /* ndef ASM */
 #endif /* MAC_NCR5380_H */
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-17 23:49:31.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:20.000000000 +1100
@@ -108,9 +108,6 @@ static int sun3scsi_release (struct Scsi
 #define NCR5380_dma_read_setup(instance, data, count) sun3scsi_dma_setup(data, count, 0)
 #define NCR5380_dma_residual sun3scsi_dma_residual
 
-#define BOARD_NORMAL	0
-#define BOARD_NCR53C400	1
-
 /* additional registers - mainly DMA control regs */
 /* these start at regbase + 8 -- directly after the NCR regs */
 struct sun3_dma_regs {
