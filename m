From: akpm@osdl.org
Subject: [patch 21/26] scsi: t128 scsi_cmnd convertion
Date: Wed, 08 Nov 2006 19:56:28 -0800
Message-ID: <200611090356.kA93uSBc003999@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:2738 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424013AbWKID4g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:56:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henne <henne@nachtwindheim.de>

Changes the obsolete Scsi_Cmnd to struct scsi_cmnd and remove the trailing
whitespaces.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/t128.h |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff -puN drivers/scsi/t128.h~scsi-t128-scsi_cmnd-convertion drivers/scsi/t128.h
--- a/drivers/scsi/t128.h~scsi-t128-scsi_cmnd-convertion
+++ a/drivers/scsi/t128.h
@@ -8,20 +8,20 @@
  *	drew@colorado.edu
  *      +1 (303) 440-4894
  *
- * DISTRIBUTION RELEASE 3. 
+ * DISTRIBUTION RELEASE 3.
  *
- * For more information, please consult 
+ * For more information, please consult
  *
  * Trantor Systems, Ltd.
  * T128/T128F/T228 SCSI Host Adapter
  * Hardware Specifications
- * 
- * Trantor Systems, Ltd. 
+ *
+ * Trantor Systems, Ltd.
  * 5415 Randall Place
  * Fremont, CA 94538
  * 1+ (415) 770-1400, FAX 1+ (415) 770-9910
- * 
- * and 
+ *
+ * and
  *
  * NCR 5380 Family
  * SCSI Protocol Controller
@@ -48,15 +48,15 @@
 #define TDEBUG_TRANSFER 0x2
 
 /*
- * The trantor boards are memory mapped. They use an NCR5380 or 
+ * The trantor boards are memory mapped. They use an NCR5380 or
  * equivalent (my sample board had part second sourced from ZILOG).
- * NCR's recommended "Pseudo-DMA" architecture is used, where 
+ * NCR's recommended "Pseudo-DMA" architecture is used, where
  * a PAL drives the DMA signals on the 5380 allowing fast, blind
- * transfers with proper handshaking. 
+ * transfers with proper handshaking.
  */
 
 /*
- * Note : a boot switch is provided for the purpose of informing the 
+ * Note : a boot switch is provided for the purpose of informing the
  * firmware to boot or not boot from attached SCSI devices.  So, I imagine
  * there are fewer people who've yanked the ROM like they do on the Seagate
  * to make bootup faster, and I'll probably use this for autodetection.
@@ -92,19 +92,20 @@
 #define T_DATA_REG_OFFSET	0x1e00	/* rw 512 bytes long */
 
 #ifndef ASM
-static int t128_abort(Scsi_Cmnd *);
+static int t128_abort(struct scsi_cmnd *);
 static int t128_biosparam(struct scsi_device *, struct block_device *,
 			  sector_t, int*);
 static int t128_detect(struct scsi_host_template *);
-static int t128_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int t128_bus_reset(Scsi_Cmnd *);
+static int t128_queue_command(struct scsi_cmnd *,
+			      void (*done)(struct scsi_cmnd *));
+static int t128_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
 
 #ifndef CAN_QUEUE
-#define CAN_QUEUE 32 
+#define CAN_QUEUE 32
 #endif
 
 #ifndef HOSTS_C
@@ -120,7 +121,7 @@ static int t128_bus_reset(Scsi_Cmnd *);
 
 #define T128_address(reg) (base + T_5380_OFFSET + ((reg) * 0x20))
 
-#if !(TDEBUG & TDEBUG_TRANSFER) 
+#if !(TDEBUG & TDEBUG_TRANSFER)
 #define NCR5380_read(reg) readb(T128_address(reg))
 #define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
 #else
@@ -129,7 +130,7 @@ static int t128_bus_reset(Scsi_Cmnd *);
     , instance->hostno, (reg), T128_address(reg))), readb(T128_address(reg)))
 
 #define NCR5380_write(reg, value) {					\
-    printk("scsi%d : write %02x to register %d at address %08x\n", 	\
+    printk("scsi%d : write %02x to register %d at address %08x\n",	\
 	    instance->hostno, (value), (reg), T128_address(reg));	\
     writeb((value), (T128_address(reg)));				\
 }
@@ -142,10 +143,10 @@ static int t128_bus_reset(Scsi_Cmnd *);
 #define NCR5380_bus_reset t128_bus_reset
 #define NCR5380_proc_info t128_proc_info
 
-/* 15 14 12 10 7 5 3 
+/* 15 14 12 10 7 5 3
    1101 0100 1010 1000 */
-   
-#define T128_IRQS 0xc4a8 
+
+#define T128_IRQS 0xc4a8
 
 #endif /* else def HOSTS_C */
 #endif /* ndef ASM */
_
