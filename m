From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: replace deprecated hosts.h file
Date: Sun, 30 May 2004 11:36:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040530093616.GA22744@devserv.devel.redhat.com>
References: <20040529142126.GA31365@devserv.devel.redhat.com> <40B8A7FA.8070802@pobox.com> <20040530084219.GA2136@devserv.devel.redhat.com> <40B9A886.2000105@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40661 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261943AbUE3Jgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 05:36:35 -0400
Content-Disposition: inline
In-Reply-To: <40B9A886.2000105@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


On Sun, May 30, 2004 at 05:25:26AM -0400, Jeff Garzik wrote:
> Arjan van de Ven wrote:
> >On Sat, May 29, 2004 at 11:10:50AM -0400, Jeff Garzik wrote:
> >
> >>Rejected, libata stays with the old headers until 2.7 (when it leaves 
> >>scsi).
> >
> >
> >Patch without libata bits below.
> 
> Bullshit, and therefore, rejected again.
> 

Would you consider naming your files more consistently ? They don't all
have sata in them ;(
(Or even move them to their own directory)

diff -purN linux-2.6.6/drivers/scsi.org/3w-xxxx.c linux-2.6.6/drivers/scsi/3w-xxxx.c
--- linux-2.6.6/drivers/scsi.org/3w-xxxx.c	2004-05-12 17:45:57.888964000 +0200
+++ linux-2.6.6/drivers/scsi/3w-xxxx.c	2004-05-12 17:46:19.061746008 +0200
@@ -220,7 +220,7 @@ MODULE_LICENSE("GPL");
 #define __3W_C			/* let 3w-xxxx.h know it is use */
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "3w-xxxx.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/53c700.c linux-2.6.6/drivers/scsi/53c700.c
--- linux-2.6.6/drivers/scsi.org/53c700.c	2004-05-10 04:32:01.000000000 +0200
+++ linux-2.6.6/drivers/scsi/53c700.c	2004-05-12 17:46:19.097740536 +0200
@@ -135,7 +135,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
diff -purN linux-2.6.6/drivers/scsi.org/53c7xx.c linux-2.6.6/drivers/scsi/53c7xx.c
--- linux-2.6.6/drivers/scsi.org/53c7xx.c	2004-05-10 04:33:22.000000000 +0200
+++ linux-2.6.6/drivers/scsi/53c7xx.c	2004-05-12 17:46:19.192726096 +0200
@@ -280,7 +280,7 @@
 #endif
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "53c7xx.h"
 #include <linux/stat.h>
 #include <linux/stddef.h>
diff -purN linux-2.6.6/drivers/scsi.org/a2091.c linux-2.6.6/drivers/scsi/a2091.c
--- linux-2.6.6/drivers/scsi.org/a2091.c	2004-05-10 04:32:37.000000000 +0200
+++ linux-2.6.6/drivers/scsi/a2091.c	2004-05-12 17:46:19.200724880 +0200
@@ -16,7 +16,7 @@
 #include <linux/spinlock.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "a2091.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/a3000.c linux-2.6.6/drivers/scsi/a3000.c
--- linux-2.6.6/drivers/scsi.org/a3000.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/a3000.c	2004-05-12 17:46:19.207723816 +0200
@@ -15,7 +15,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "a3000.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/advansys.c linux-2.6.6/drivers/scsi/advansys.c
--- linux-2.6.6/drivers/scsi.org/advansys.c	2004-05-10 04:32:27.000000000 +0200
+++ linux-2.6.6/drivers/scsi/advansys.c	2004-05-12 17:46:19.496679888 +0200
@@ -807,7 +807,7 @@
 #include <asm/dma.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "advansys.h"
 #ifdef CONFIG_PCI
 #include <linux/pci.h>
diff -purN linux-2.6.6/drivers/scsi.org/aha1542.c linux-2.6.6/drivers/scsi/aha1542.c
--- linux-2.6.6/drivers/scsi.org/aha1542.c	2004-05-10 04:32:37.000000000 +0200
+++ linux-2.6.6/drivers/scsi/aha1542.c	2004-05-12 17:46:19.591665448 +0200
@@ -47,7 +47,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "aha1542.h"
 
 #define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
diff -purN linux-2.6.6/drivers/scsi.org/aha1740.c linux-2.6.6/drivers/scsi/aha1740.c
--- linux-2.6.6/drivers/scsi.org/aha1740.c	2004-05-10 04:32:26.000000000 +0200
+++ linux-2.6.6/drivers/scsi/aha1740.c	2004-05-12 17:46:19.605663320 +0200
@@ -56,7 +56,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "aha1740.h"
 
 /* IF YOU ARE HAVING PROBLEMS WITH THIS DRIVER, AND WANT TO WATCH
diff -purN linux-2.6.6/drivers/scsi.org/aic7xxx/aic79xx_osm.h linux-2.6.6/drivers/scsi/aic7xxx/aic79xx_osm.h
--- linux-2.6.6/drivers/scsi.org/aic7xxx/aic79xx_osm.h	2004-05-10 04:32:52.000000000 +0200
+++ linux-2.6.6/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-05-12 17:46:26.646592936 +0200
@@ -68,7 +68,7 @@
 /* Core SCSI definitions */
 #define AIC_LIB_PREFIX ahd
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 /* Name space conflict with BSD queue macros */
 #ifdef LIST_HEAD
diff -purN linux-2.6.6/drivers/scsi.org/aic7xxx/aic7xxx_osm.h linux-2.6.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
--- linux-2.6.6/drivers/scsi.org/aic7xxx/aic7xxx_osm.h	2004-05-12 17:45:57.901962000 +0200
+++ linux-2.6.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-05-12 17:46:26.710583208 +0200
@@ -85,7 +85,7 @@
 /* Core SCSI definitions */
 #define AIC_LIB_PREFIX ahc
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 /* Name space conflict with BSD queue macros */
 #ifdef LIST_HEAD
diff -purN linux-2.6.6/drivers/scsi.org/aic7xxx/aiclib.c linux-2.6.6/drivers/scsi/aic7xxx/aiclib.c
--- linux-2.6.6/drivers/scsi.org/aic7xxx/aiclib.c	2004-05-10 04:32:37.000000000 +0200
+++ linux-2.6.6/drivers/scsi/aic7xxx/aiclib.c	2004-05-12 17:46:25.067832944 +0200
@@ -36,7 +36,7 @@
 
 /* Core SCSI definitions */
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "aiclib.h"
 #include "cam.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/aic7xxx_old.c linux-2.6.6/drivers/scsi/aic7xxx_old.c
--- linux-2.6.6/drivers/scsi.org/aic7xxx_old.c	2004-05-12 17:45:57.912961000 +0200
+++ linux-2.6.6/drivers/scsi/aic7xxx_old.c	2004-05-12 17:46:19.778637024 +0200
@@ -239,7 +239,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "aic7xxx_old/aic7xxx.h"
 
 #include "aic7xxx_old/sequencer.h"
diff -purN linux-2.6.6/drivers/scsi.org/amiga7xx.c linux-2.6.6/drivers/scsi/amiga7xx.c
--- linux-2.6.6/drivers/scsi.org/amiga7xx.c	2004-05-10 04:32:28.000000000 +0200
+++ linux-2.6.6/drivers/scsi/amiga7xx.c	2004-05-12 17:46:19.784636112 +0200
@@ -25,7 +25,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "53c7xx.h"
 #include "amiga7xx.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/atari_scsi.c linux-2.6.6/drivers/scsi/atari_scsi.c
--- linux-2.6.6/drivers/scsi.org/atari_scsi.c	2004-05-10 04:33:21.000000000 +0200
+++ linux-2.6.6/drivers/scsi/atari_scsi.c	2004-05-12 17:46:19.876622128 +0200
@@ -102,7 +102,7 @@
 #include <asm/bitops.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "atari_scsi.h"
 #include "NCR5380.h"
 #include <asm/atari_stdma.h>
diff -purN linux-2.6.6/drivers/scsi.org/atp870u.c linux-2.6.6/drivers/scsi/atp870u.c
--- linux-2.6.6/drivers/scsi.org/atp870u.c	2004-05-10 04:32:28.000000000 +0200
+++ linux-2.6.6/drivers/scsi/atp870u.c	2004-05-12 17:46:19.920615440 +0200
@@ -34,7 +34,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "atp870u.h"
 
 /*
diff -purN linux-2.6.6/drivers/scsi.org/blz1230.c linux-2.6.6/drivers/scsi/blz1230.c
--- linux-2.6.6/drivers/scsi.org/blz1230.c	2004-05-10 04:32:53.000000000 +0200
+++ linux-2.6.6/drivers/scsi/blz1230.c	2004-05-12 17:46:19.929614072 +0200
@@ -28,7 +28,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <linux/zorro.h>
diff -purN linux-2.6.6/drivers/scsi.org/blz2060.c linux-2.6.6/drivers/scsi/blz2060.c
--- linux-2.6.6/drivers/scsi.org/blz2060.c	2004-05-10 04:32:29.000000000 +0200
+++ linux-2.6.6/drivers/scsi/blz2060.c	2004-05-12 17:46:19.937612856 +0200
@@ -28,7 +28,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <linux/zorro.h>
diff -purN linux-2.6.6/drivers/scsi.org/BusLogic.c linux-2.6.6/drivers/scsi/BusLogic.c
--- linux-2.6.6/drivers/scsi.org/BusLogic.c	2004-05-10 04:33:20.000000000 +0200
+++ linux-2.6.6/drivers/scsi/BusLogic.c	2004-05-12 17:46:20.007602216 +0200
@@ -48,7 +48,7 @@
 #include <asm/system.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "BusLogic.h"
 #include "FlashPoint.c"
 
diff -purN linux-2.6.6/drivers/scsi.org/bvme6000.c linux-2.6.6/drivers/scsi/bvme6000.c
--- linux-2.6.6/drivers/scsi.org/bvme6000.c	2004-05-10 04:32:00.000000000 +0200
+++ linux-2.6.6/drivers/scsi/bvme6000.c	2004-05-12 17:46:20.012601456 +0200
@@ -17,7 +17,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "53c7xx.h"
 #include "bvme6000.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/constants.c linux-2.6.6/drivers/scsi/constants.c
--- linux-2.6.6/drivers/scsi.org/constants.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/constants.c	2004-05-12 17:46:20.034598112 +0200
@@ -12,7 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/kernel.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #define CONST_COMMAND   0x01
 #define CONST_STATUS    0x02
diff -purN linux-2.6.6/drivers/scsi.org/cpqfcTScontrol.c linux-2.6.6/drivers/scsi/cpqfcTScontrol.c
--- linux-2.6.6/drivers/scsi.org/cpqfcTScontrol.c	2004-05-10 04:32:00.000000000 +0200
+++ linux-2.6.6/drivers/scsi/cpqfcTScontrol.c	2004-05-12 17:46:20.071592488 +0200
@@ -45,7 +45,7 @@
 #include <linux/spinlock.h>
 
 #include "scsi.h"
-#include "hosts.h"   // Scsi_Host definition for INT handler
+#include <scsi/scsi_host.h>   // Scsi_Host definition for INT handler
 #include "cpqfcTSchip.h"
 #include "cpqfcTSstructs.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/cpqfcTSinit.c linux-2.6.6/drivers/scsi/cpqfcTSinit.c
--- linux-2.6.6/drivers/scsi.org/cpqfcTSinit.c	2004-05-10 04:31:59.000000000 +0200
+++ linux-2.6.6/drivers/scsi/cpqfcTSinit.c	2004-05-12 17:46:20.116585648 +0200
@@ -51,7 +51,7 @@
 #include <asm/irq.h>
 #include <linux/spinlock.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include "cpqfcTSchip.h"
 #include "cpqfcTSstructs.h"
@@ -1266,7 +1266,7 @@ static void QueLinkDownCmnd( CPQFCHBA *c
 
 
 
-// The file "hosts.h" says not to call scsi_done from
+// The file <scsi/scsi_host.h> says not to call scsi_done from
 // inside _queuecommand, so we'll do it from the heartbeat timer
 // (clarification: Turns out it's ok to call scsi_done from queuecommand 
 // for cases that don't go to the hardware like scsi cmds destined
diff -purN linux-2.6.6/drivers/scsi.org/cpqfcTSworker.c linux-2.6.6/drivers/scsi/cpqfcTSworker.c
--- linux-2.6.6/drivers/scsi.org/cpqfcTSworker.c	2004-05-10 04:33:12.000000000 +0200
+++ linux-2.6.6/drivers/scsi/cpqfcTSworker.c	2004-05-12 17:46:20.222569536 +0200
@@ -39,7 +39,7 @@
 #include <asm/dma.h>
 
 #include "scsi.h"
-#include "hosts.h"   // struct Scsi_Host definition for T handler
+#include <scsi/scsi_host.h>   // struct Scsi_Host definition for T handler
 #include "cpqfcTSchip.h"
 #include "cpqfcTSstructs.h"
 #include "cpqfcTStrigger.h"
diff -purN linux-2.6.6/drivers/scsi.org/cyberstorm.c linux-2.6.6/drivers/scsi/cyberstorm.c
--- linux-2.6.6/drivers/scsi.org/cyberstorm.c	2004-05-10 04:33:12.000000000 +0200
+++ linux-2.6.6/drivers/scsi/cyberstorm.c	2004-05-12 17:46:20.232568016 +0200
@@ -31,7 +31,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <linux/zorro.h>
diff -purN linux-2.6.6/drivers/scsi.org/cyberstormII.c linux-2.6.6/drivers/scsi/cyberstormII.c
--- linux-2.6.6/drivers/scsi.org/cyberstormII.c	2004-05-10 04:33:13.000000000 +0200
+++ linux-2.6.6/drivers/scsi/cyberstormII.c	2004-05-12 17:46:20.240566800 +0200
@@ -27,7 +27,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <linux/zorro.h>
diff -purN linux-2.6.6/drivers/scsi.org/dc395x.c linux-2.6.6/drivers/scsi/dc395x.c
--- linux-2.6.6/drivers/scsi.org/dc395x.c	2004-05-10 04:32:01.000000000 +0200
+++ linux-2.6.6/drivers/scsi/dc395x.c	2004-05-12 17:46:20.319554792 +0200
@@ -53,7 +53,7 @@
 #include <linux/blkdev.h>
 #include <asm/io.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "dc395x.h"
 #include <scsi/scsicam.h>	/* needed for scsicam_bios_param */
 #include <linux/interrupt.h>
diff -purN linux-2.6.6/drivers/scsi.org/dec_esp.c linux-2.6.6/drivers/scsi/dec_esp.c
--- linux-2.6.6/drivers/scsi.org/dec_esp.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/dec_esp.c	2004-05-12 17:46:20.331552968 +0200
@@ -29,7 +29,7 @@
 #include <linux/stat.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <asm/irq.h>
diff -purN linux-2.6.6/drivers/scsi.org/dmx3191d.c linux-2.6.6/drivers/scsi/dmx3191d.c
--- linux-2.6.6/drivers/scsi.org/dmx3191d.c	2004-05-10 04:32:39.000000000 +0200
+++ linux-2.6.6/drivers/scsi/dmx3191d.c	2004-05-12 17:46:20.337552056 +0200
@@ -34,7 +34,7 @@
 #include <linux/delay.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "dmx3191d.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/dpt_i2o.c linux-2.6.6/drivers/scsi/dpt_i2o.c
--- linux-2.6.6/drivers/scsi.org/dpt_i2o.c	2004-05-10 04:33:13.000000000 +0200
+++ linux-2.6.6/drivers/scsi/dpt_i2o.c	2004-05-12 17:46:20.390544000 +0200
@@ -65,7 +65,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 #include <asm/io.h>		/* for virt_to_bus, etc. */
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "dpt/dptsig.h"
 #include "dpti.h"
diff -purN linux-2.6.6/drivers/scsi.org/dtc.c linux-2.6.6/drivers/scsi/dtc.c
--- linux-2.6.6/drivers/scsi.org/dtc.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/dtc.c	2004-05-12 17:46:20.401542328 +0200
@@ -84,7 +84,7 @@
 #include <linux/interrupt.h>
 #include <asm/io.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "dtc.h"
 #define AUTOPROBE_IRQ
 #include "NCR5380.h"
diff -purN linux-2.6.6/drivers/scsi.org/eata.c linux-2.6.6/drivers/scsi/eata.c
--- linux-2.6.6/drivers/scsi.org/eata.c	2004-05-10 04:33:13.000000000 +0200
+++ linux-2.6.6/drivers/scsi/eata.c	2004-05-12 17:46:20.441536248 +0200
@@ -495,7 +495,7 @@
 #include <linux/spinlock.h>
 #include <scsi/scsicam.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 
diff -purN linux-2.6.6/drivers/scsi.org/eata_pio.c linux-2.6.6/drivers/scsi/eata_pio.c
--- linux-2.6.6/drivers/scsi.org/eata_pio.c	2004-05-10 04:32:52.000000000 +0200
+++ linux-2.6.6/drivers/scsi/eata_pio.c	2004-05-12 17:46:20.460533360 +0200
@@ -63,7 +63,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
 #include "eata_generic.h"
diff -purN linux-2.6.6/drivers/scsi.org/esp.c linux-2.6.6/drivers/scsi/esp.c
--- linux-2.6.6/drivers/scsi.org/esp.c	2004-05-10 04:33:21.000000000 +0200
+++ linux-2.6.6/drivers/scsi/esp.c	2004-05-12 17:46:20.529522872 +0200
@@ -27,7 +27,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "esp.h"
 
 #include <asm/sbus.h>
diff -purN linux-2.6.6/drivers/scsi.org/fastlane.c linux-2.6.6/drivers/scsi/fastlane.c
--- linux-2.6.6/drivers/scsi.org/fastlane.c	2004-05-10 04:32:28.000000000 +0200
+++ linux-2.6.6/drivers/scsi/fastlane.c	2004-05-12 17:46:20.539521352 +0200
@@ -36,7 +36,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <linux/zorro.h>
diff -purN linux-2.6.6/drivers/scsi.org/fcal.c linux-2.6.6/drivers/scsi/fcal.c
--- linux-2.6.6/drivers/scsi.org/fcal.c	2004-05-10 04:31:59.000000000 +0200
+++ linux-2.6.6/drivers/scsi/fcal.c	2004-05-12 17:46:20.547520136 +0200
@@ -21,7 +21,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "../fc4/fcp_impl.h"
 #include "fcal.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/fd_mcs.c linux-2.6.6/drivers/scsi/fd_mcs.c
--- linux-2.6.6/drivers/scsi.org/fd_mcs.c	2004-05-10 04:32:28.000000000 +0200
+++ linux-2.6.6/drivers/scsi/fd_mcs.c	2004-05-12 17:46:20.572516336 +0200
@@ -93,7 +93,7 @@
 #include <asm/system.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "fd_mcs.h"
 
 #define DRIVER_VERSION "v0.2 by ZP Gu<zpg@castle.net>"
diff -purN linux-2.6.6/drivers/scsi.org/fdomain.c linux-2.6.6/drivers/scsi/fdomain.c
--- linux-2.6.6/drivers/scsi.org/fdomain.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/fdomain.c	2004-05-12 17:46:20.603511624 +0200
@@ -284,7 +284,7 @@
 #include <asm/system.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 MODULE_AUTHOR("Rickard E. Faith");
 MODULE_DESCRIPTION("Future domain SCSI driver");
--- linux-2.6.6/drivers/scsi.org/g_NCR5380.c	2004-05-10 04:32:02.000000000 +0200
+++ linux-2.6.6/drivers/scsi/g_NCR5380.c	2004-05-12 17:46:20.928462224 +0200
@@ -107,7 +107,7 @@
 #include <linux/sched.h>
 #include <linux/blkdev.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "g_NCR5380.h"
 #include "NCR5380.h"
 #include <linux/stat.h>
diff -purN linux-2.6.6/drivers/scsi.org/gvp11.c linux-2.6.6/drivers/scsi/gvp11.c
--- linux-2.6.6/drivers/scsi.org/gvp11.c	2004-05-10 04:33:20.000000000 +0200
+++ linux-2.6.6/drivers/scsi/gvp11.c	2004-05-12 17:46:20.941460248 +0200
@@ -16,7 +16,7 @@
 #include <linux/spinlock.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "gvp11.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/i60uscsi.c linux-2.6.6/drivers/scsi/i60uscsi.c
--- linux-2.6.6/drivers/scsi.org/i60uscsi.c	2004-05-10 04:32:02.000000000 +0200
+++ linux-2.6.6/drivers/scsi/i60uscsi.c	2004-05-12 17:46:20.966456448 +0200
@@ -81,7 +81,7 @@
 #include <asm/io.h>
 #include <linux/blkdev.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "inia100.h"
 
 #define JIFFIES_TO_MS(t) ((t) * 1000 / HZ)
diff -purN linux-2.6.6/drivers/scsi.org/ibmmca.c linux-2.6.6/drivers/scsi/ibmmca.c
--- linux-2.6.6/drivers/scsi.org/ibmmca.c	2004-05-10 04:32:00.000000000 +0200
+++ linux-2.6.6/drivers/scsi/ibmmca.c	2004-05-12 17:46:21.057442616 +0200
@@ -45,7 +45,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "ibmmca.h"
 
 /* current version of this driver-source: */
diff -purN linux-2.6.6/drivers/scsi.org/ide-scsi.c linux-2.6.6/drivers/scsi/ide-scsi.c
--- linux-2.6.6/drivers/scsi.org/ide-scsi.c	2004-05-10 04:32:52.000000000 +0200
+++ linux-2.6.6/drivers/scsi/ide-scsi.c	2004-05-12 17:46:21.079439272 +0200
@@ -51,7 +51,7 @@
 #include <asm/uaccess.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/sg.h>
 
 #define IDESCSI_DEBUG_LOG		0
diff -purN linux-2.6.6/drivers/scsi.org/imm.h linux-2.6.6/drivers/scsi/imm.h
--- linux-2.6.6/drivers/scsi.org/imm.h	2004-05-12 17:45:57.916960000 +0200
+++ linux-2.6.6/drivers/scsi/imm.h	2004-05-12 17:46:23.837020056 +0200
@@ -79,7 +79,7 @@
 #include  <linux/interrupt.h>
 
 #include  <asm/io.h>
-#include  "hosts.h"
+#include  <scsi/scsi_host.h>
 /* batteries not included :-) */
 
 /*
diff -purN linux-2.6.6/drivers/scsi.org/in2000.c linux-2.6.6/drivers/scsi/in2000.c
--- linux-2.6.6/drivers/scsi.org/in2000.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/in2000.c	2004-05-12 17:46:21.141429848 +0200
@@ -126,7 +126,7 @@
 #include <asm/system.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #define IN2000_VERSION    "1.33-2.5"
 #define IN2000_DATE       "2002/11/03"
diff -purN linux-2.6.6/drivers/scsi.org/ini9100u.c linux-2.6.6/drivers/scsi/ini9100u.c
--- linux-2.6.6/drivers/scsi.org/ini9100u.c	2004-05-12 17:45:57.918960000 +0200
+++ linux-2.6.6/drivers/scsi/ini9100u.c	2004-05-12 17:46:21.156427568 +0200
@@ -136,7 +136,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "ini9100u.h"
 
 #ifdef DEBUG_i91u
diff -purN linux-2.6.6/drivers/scsi.org/ips.c linux-2.6.6/drivers/scsi/ips.c
--- linux-2.6.6/drivers/scsi.org/ips.c	2004-05-10 04:31:58.000000000 +0200
+++ linux-2.6.6/drivers/scsi/ips.c	2004-05-12 17:46:21.385392760 +0200
@@ -176,7 +176,7 @@
 #include <scsi/sg.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "ips.h"
 
 #include <linux/module.h>
diff -purN linux-2.6.6/drivers/scsi.org/jazz_esp.c linux-2.6.6/drivers/scsi/jazz_esp.c
--- linux-2.6.6/drivers/scsi.org/jazz_esp.c	2004-05-10 04:32:00.000000000 +0200
+++ linux-2.6.6/drivers/scsi/jazz_esp.c	2004-05-12 17:46:21.393391544 +0200
@@ -16,7 +16,7 @@
 #include <linux/stat.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <asm/irq.h>
diff -purN linux-2.6.6/drivers/scsi.org/lasi700.c linux-2.6.6/drivers/scsi/lasi700.c
--- linux-2.6.6/drivers/scsi.org/lasi700.c	2004-05-10 04:32:00.000000000 +0200
+++ linux-2.6.6/drivers/scsi/lasi700.c	2004-05-12 17:46:21.399390632 +0200
@@ -50,7 +50,7 @@
 #include <asm/delay.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "lasi700.h"
 #include "53c700.h"
diff -purN linux-2.6.6/drivers/scsi.org/mac_esp.c linux-2.6.6/drivers/scsi/mac_esp.c
--- linux-2.6.6/drivers/scsi.org/mac_esp.c	2004-05-10 04:32:36.000000000 +0200
+++ linux-2.6.6/drivers/scsi/mac_esp.c	2004-05-12 17:46:21.505374520 +0200
@@ -26,7 +26,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <asm/io.h>
diff -purN linux-2.6.6/drivers/scsi.org/mac_scsi.c linux-2.6.6/drivers/scsi/mac_scsi.c
--- linux-2.6.6/drivers/scsi.org/mac_scsi.c	2004-05-10 04:32:00.000000000 +0200
+++ linux-2.6.6/drivers/scsi/mac_scsi.c	2004-05-12 17:46:21.518372544 +0200
@@ -52,7 +52,7 @@
 #include <asm/mac_via.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "mac_scsi.h"
 #include "NCR5380.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/mca_53c9x.c linux-2.6.6/drivers/scsi/mca_53c9x.c
--- linux-2.6.6/drivers/scsi.org/mca_53c9x.c	2004-05-10 04:32:26.000000000 +0200
+++ linux-2.6.6/drivers/scsi/mca_53c9x.c	2004-05-12 17:46:21.530370720 +0200
@@ -43,7 +43,7 @@
 #include <linux/mca-legacy.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <asm/dma.h>
diff -purN linux-2.6.6/drivers/scsi.org/megaraid.c linux-2.6.6/drivers/scsi/megaraid.c
--- linux-2.6.6/drivers/scsi.org/megaraid.c	2004-05-12 17:45:58.829821000 +0200
+++ linux-2.6.6/drivers/scsi/megaraid.c	2004-05-12 17:46:21.612358256 +0200
@@ -49,7 +49,7 @@
 #include <scsi/scsicam.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "megaraid.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/mvme147.c linux-2.6.6/drivers/scsi/mvme147.c
--- linux-2.6.6/drivers/scsi.org/mvme147.c	2004-05-10 04:32:26.000000000 +0200
+++ linux-2.6.6/drivers/scsi/mvme147.c	2004-05-12 17:46:21.653352024 +0200
@@ -11,7 +11,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "mvme147.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/mvme16x.c linux-2.6.6/drivers/scsi/mvme16x.c
--- linux-2.6.6/drivers/scsi.org/mvme16x.c	2004-05-10 04:33:13.000000000 +0200
+++ linux-2.6.6/drivers/scsi/mvme16x.c	2004-05-12 17:46:21.658351264 +0200
@@ -15,7 +15,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "53c7xx.h"
 #include "mvme16x.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/NCR53c406a.c linux-2.6.6/drivers/scsi/NCR53c406a.c
--- linux-2.6.6/drivers/scsi.org/NCR53c406a.c	2004-05-10 04:32:30.000000000 +0200
+++ linux-2.6.6/drivers/scsi/NCR53c406a.c	2004-05-12 17:46:21.729340472 +0200
@@ -54,7 +54,7 @@
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 /* ============================================================= */
 
diff -purN linux-2.6.6/drivers/scsi.org/ncr53c8xx.c linux-2.6.6/drivers/scsi/ncr53c8xx.c
--- linux-2.6.6/drivers/scsi.org/ncr53c8xx.c	2004-05-12 17:45:57.946955000 +0200
+++ linux-2.6.6/drivers/scsi/ncr53c8xx.c	2004-05-12 17:46:21.877317976 +0200
@@ -138,7 +138,7 @@
 #include <asm/system.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "ncr53c8xx.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/NCR53C9x.c linux-2.6.6/drivers/scsi/NCR53C9x.c
--- linux-2.6.6/drivers/scsi.org/NCR53C9x.c	2004-05-10 04:32:26.000000000 +0200
+++ linux-2.6.6/drivers/scsi/NCR53C9x.c	2004-05-12 17:46:21.937308856 +0200
@@ -36,7 +36,7 @@
 #include <linux/init.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <asm/system.h>
diff -purN linux-2.6.6/drivers/scsi.org/NCR_D700.c linux-2.6.6/drivers/scsi/NCR_D700.c
--- linux-2.6.6/drivers/scsi.org/NCR_D700.c	2004-05-10 04:32:01.000000000 +0200
+++ linux-2.6.6/drivers/scsi/NCR_D700.c	2004-05-12 17:46:21.948307184 +0200
@@ -100,7 +100,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "53c700.h"
 #include "NCR_D700.h"
diff -purN linux-2.6.6/drivers/scsi.org/NCR_Q720.c linux-2.6.6/drivers/scsi/NCR_Q720.c
--- linux-2.6.6/drivers/scsi.org/NCR_Q720.c	2004-05-10 04:32:01.000000000 +0200
+++ linux-2.6.6/drivers/scsi/NCR_Q720.c	2004-05-12 17:46:21.960305360 +0200
@@ -16,7 +16,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "ncr53c8xx.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/nsp32.c linux-2.6.6/drivers/scsi/nsp32.c
--- linux-2.6.6/drivers/scsi.org/nsp32.c	2004-05-12 17:45:57.949955000 +0200
+++ linux-2.6.6/drivers/scsi/nsp32.c	2004-05-12 17:46:22.028295024 +0200
@@ -45,7 +45,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi.h>
 
diff -purN linux-2.6.6/drivers/scsi.org/oktagon_esp.c linux-2.6.6/drivers/scsi/oktagon_esp.c
--- linux-2.6.6/drivers/scsi.org/oktagon_esp.c	2004-05-10 04:31:59.000000000 +0200
+++ linux-2.6.6/drivers/scsi/oktagon_esp.c	2004-05-12 17:46:22.048291984 +0200
@@ -29,7 +29,7 @@
 
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <linux/zorro.h>
diff -purN linux-2.6.6/drivers/scsi.org/osst.c linux-2.6.6/drivers/scsi/osst.c
--- linux-2.6.6/drivers/scsi.org/osst.c	2004-05-10 04:32:29.000000000 +0200
+++ linux-2.6.6/drivers/scsi/osst.c	2004-05-12 17:46:22.138278304 +0200
@@ -61,7 +61,7 @@ const char * osst_version = "0.99.1";
 #define OSST_DEB_MSG  KERN_NOTICE
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 
diff -purN linux-2.6.6/drivers/scsi.org/pas16.c linux-2.6.6/drivers/scsi/pas16.c
--- linux-2.6.6/drivers/scsi.org/pas16.c	2004-05-10 04:31:58.000000000 +0200
+++ linux-2.6.6/drivers/scsi/pas16.c	2004-05-12 17:46:22.151276328 +0200
@@ -125,7 +125,7 @@
 #include <linux/init.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "pas16.h"
 #define AUTOPROBE_IRQ
 #include "NCR5380.h"
diff -purN linux-2.6.6/drivers/scsi.org/pc980155.c linux-2.6.6/drivers/scsi/pc980155.c
--- linux-2.6.6/drivers/scsi.org/pc980155.c	2004-05-10 04:31:59.000000000 +0200
+++ linux-2.6.6/drivers/scsi/pc980155.c	2004-05-12 17:46:22.159275112 +0200
@@ -20,7 +20,7 @@
 #include <asm/dma.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "pc980155.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/pci2000.c linux-2.6.6/drivers/scsi/pci2000.c
--- linux-2.6.6/drivers/scsi.org/pci2000.c	2004-05-10 04:32:53.000000000 +0200
+++ linux-2.6.6/drivers/scsi/pci2000.c	2004-05-12 17:46:22.175272680 +0200
@@ -54,7 +54,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "pci2000.h"
 #include "psi_roy.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/pci2220i.c linux-2.6.6/drivers/scsi/pci2220i.c
--- linux-2.6.6/drivers/scsi.org/pci2220i.c	2004-05-10 04:31:58.000000000 +0200
+++ linux-2.6.6/drivers/scsi/pci2220i.c	2004-05-12 17:46:22.223265384 +0200
@@ -59,7 +59,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "pci2220i.h"
 #include "psi_dale.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/pcmcia/aha152x_stub.c linux-2.6.6/drivers/scsi/pcmcia/aha152x_stub.c
--- linux-2.6.6/drivers/scsi.org/pcmcia/aha152x_stub.c	2004-05-10 04:33:19.000000000 +0200
+++ linux-2.6.6/drivers/scsi/pcmcia/aha152x_stub.c	2004-05-12 17:46:25.283800112 +0200
@@ -47,7 +47,7 @@
 #include <scsi/scsi_ioctl.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "aha152x.h"
 
 #include <pcmcia/version.h>
diff -purN linux-2.6.6/drivers/scsi.org/pcmcia/fdomain_stub.c linux-2.6.6/drivers/scsi/pcmcia/fdomain_stub.c
--- linux-2.6.6/drivers/scsi.org/pcmcia/fdomain_stub.c	2004-05-10 04:32:39.000000000 +0200
+++ linux-2.6.6/drivers/scsi/pcmcia/fdomain_stub.c	2004-05-12 17:46:25.295798288 +0200
@@ -44,7 +44,7 @@
 #include <scsi/scsi_ioctl.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include <pcmcia/version.h>
 #include <pcmcia/cs_types.h>
diff -purN linux-2.6.6/drivers/scsi.org/pcmcia/qlogic_stub.c linux-2.6.6/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.6/drivers/scsi.org/pcmcia/qlogic_stub.c	2004-05-12 17:45:57.955954000 +0200
+++ linux-2.6.6/drivers/scsi/pcmcia/qlogic_stub.c	2004-05-12 17:46:25.353789472 +0200
@@ -46,7 +46,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "../qlogicfas408.h"
 
 #include <pcmcia/version.h>
diff -purN linux-2.6.6/drivers/scsi.org/pluto.c linux-2.6.6/drivers/scsi/pluto.c
--- linux-2.6.6/drivers/scsi.org/pluto.c	2004-05-10 04:32:27.000000000 +0200
+++ linux-2.6.6/drivers/scsi/pluto.c	2004-05-12 17:46:22.232264016 +0200
@@ -21,7 +21,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "../fc4/fcp_impl.h"
 #include "pluto.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/ppa.h linux-2.6.6/drivers/scsi/ppa.h
--- linux-2.6.6/drivers/scsi.org/ppa.h	2004-05-12 17:45:57.959953000 +0200
+++ linux-2.6.6/drivers/scsi/ppa.h	2004-05-12 17:46:24.069984640 +0200
@@ -86,7 +86,7 @@
 #include  <linux/interrupt.h>
 
 #include  <asm/io.h>
-#include  "hosts.h"
+#include  <scsi/scsi_host.h>
 /* batteries not included :-) */
 
 /*
diff -purN linux-2.6.6/drivers/scsi.org/psi240i.c linux-2.6.6/drivers/scsi/psi240i.c
--- linux-2.6.6/drivers/scsi.org/psi240i.c	2004-05-10 04:32:53.000000000 +0200
+++ linux-2.6.6/drivers/scsi/psi240i.c	2004-05-12 17:46:22.268258544 +0200
@@ -41,7 +41,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "psi240i.h"
 #include "psi_chip.h"
diff -purN linux-2.6.6/drivers/scsi.org/qla1280.c linux-2.6.6/drivers/scsi/qla1280.c
--- linux-2.6.6/drivers/scsi.org/qla1280.c	2004-05-12 17:45:57.962953000 +0200
+++ linux-2.6.6/drivers/scsi/qla1280.c	2004-05-12 17:46:22.348246384 +0200
@@ -357,7 +357,7 @@
 #else
 #include <linux/blk.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "sd.h"
 #endif
 
diff -purN linux-2.6.6/drivers/scsi.org/qla2xxx/qla_os.h linux-2.6.6/drivers/scsi/qla2xxx/qla_os.h
--- linux-2.6.6/drivers/scsi.org/qla2xxx/qla_os.h	2004-05-10 04:32:27.000000000 +0200
+++ linux-2.6.6/drivers/scsi/qla2xxx/qla_os.h	2004-05-12 17:46:26.968543992 +0200
@@ -59,7 +59,7 @@
 #include <asm/uaccess.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsicam.h>
 #include <scsi/scsi_ioctl.h>
diff -purN linux-2.6.6/drivers/scsi.org/qlogicfas408.c linux-2.6.6/drivers/scsi/qlogicfas408.c
--- linux-2.6.6/drivers/scsi.org/qlogicfas408.c	2004-05-12 17:45:58.164922000 +0200
+++ linux-2.6.6/drivers/scsi/qlogicfas408.c	2004-05-12 17:46:22.361244408 +0200
@@ -56,7 +56,7 @@
 #include <asm/dma.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "qlogicfas408.h"
 
 /*----------------------------------------------------------------*/
diff -purN linux-2.6.6/drivers/scsi.org/qlogicfas.c linux-2.6.6/drivers/scsi/qlogicfas.c
--- linux-2.6.6/drivers/scsi.org/qlogicfas.c	2004-05-12 17:45:58.162923000 +0200
+++ linux-2.6.6/drivers/scsi/qlogicfas.c	2004-05-12 17:46:22.368243344 +0200
@@ -32,7 +32,7 @@
 #include <asm/dma.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "qlogicfas408.h"
 
 /* Set the following to 2 to use normal interrupt (active high/totempole-
diff -purN linux-2.6.6/drivers/scsi.org/qlogicfc.c linux-2.6.6/drivers/scsi/qlogicfc.c
--- linux-2.6.6/drivers/scsi.org/qlogicfc.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/qlogicfc.c	2004-05-12 17:46:22.562213856 +0200
@@ -64,7 +64,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #define pci64_dma_hi32(a) ((u32) (0xffffffff & (((u64)(a))>>32)))
 #define pci64_dma_lo32(a) ((u32) (0xffffffff & (((u64)(a)))))
diff -purN linux-2.6.6/drivers/scsi.org/qlogicisp.c linux-2.6.6/drivers/scsi/qlogicisp.c
--- linux-2.6.6/drivers/scsi.org/qlogicisp.c	2004-05-10 04:33:21.000000000 +0200
+++ linux-2.6.6/drivers/scsi/qlogicisp.c	2004-05-12 17:46:22.630203520 +0200
@@ -36,7 +36,7 @@
 #include <asm/irq.h>
 #include <asm/byteorder.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "qlogicisp.h"
 
 /* Configuration section *****************************************************/
diff -purN linux-2.6.6/drivers/scsi.org/qlogicpti.c linux-2.6.6/drivers/scsi/qlogicpti.c
--- linux-2.6.6/drivers/scsi.org/qlogicpti.c	2004-05-10 04:32:53.000000000 +0200
+++ linux-2.6.6/drivers/scsi/qlogicpti.c	2004-05-12 17:46:22.678196224 +0200
@@ -27,7 +27,7 @@
 #include <asm/byteorder.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "qlogicpti.h"
 
 #include <asm/sbus.h>
diff -purN linux-2.6.6/drivers/scsi.org/scsicam.c linux-2.6.6/drivers/scsi/scsicam.c
--- linux-2.6.6/drivers/scsi.org/scsicam.c	2004-05-10 04:32:39.000000000 +0200
+++ linux-2.6.6/drivers/scsi/scsicam.c	2004-05-12 17:46:22.788179504 +0200
@@ -19,7 +19,7 @@
 #include <linux/buffer_head.h>
 #include <asm/unaligned.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
 static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
diff -purN linux-2.6.6/drivers/scsi.org/scsi_debug.c linux-2.6.6/drivers/scsi/scsi_debug.c
--- linux-2.6.6/drivers/scsi.org/scsi_debug.c	2004-05-10 04:32:51.000000000 +0200
+++ linux-2.6.6/drivers/scsi/scsi_debug.c	2004-05-12 17:46:22.818174944 +0200
@@ -43,7 +43,7 @@
 
 #include <linux/blkdev.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
 #include <linux/stat.h>
diff -purN linux-2.6.6/drivers/scsi.org/scsi_devinfo.c linux-2.6.6/drivers/scsi/scsi_devinfo.c
--- linux-2.6.6/drivers/scsi.org/scsi_devinfo.c	2004-05-10 04:32:27.000000000 +0200
+++ linux-2.6.6/drivers/scsi/scsi_devinfo.c	2004-05-12 17:46:22.830173120 +0200
@@ -9,7 +9,7 @@
 #include <scsi/scsi_devinfo.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "scsi_priv.h"
 
 /*
diff -purN linux-2.6.6/drivers/scsi.org/scsi_error.c linux-2.6.6/drivers/scsi/scsi_error.c
--- linux-2.6.6/drivers/scsi.org/scsi_error.c	2004-05-10 04:31:58.000000000 +0200
+++ linux-2.6.6/drivers/scsi/scsi_error.c	2004-05-12 17:46:22.861168408 +0200
@@ -26,7 +26,7 @@
 #include <scsi/scsi_ioctl.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
diff -purN linux-2.6.6/drivers/scsi.org/scsi_ioctl.c linux-2.6.6/drivers/scsi/scsi_ioctl.c
--- linux-2.6.6/drivers/scsi.org/scsi_ioctl.c	2004-05-10 04:33:20.000000000 +0200
+++ linux-2.6.6/drivers/scsi/scsi_ioctl.c	2004-05-12 17:46:22.871166888 +0200
@@ -20,7 +20,7 @@
 
 #include <linux/blkdev.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 
 #include "scsi_logging.h"
diff -purN linux-2.6.6/drivers/scsi.org/scsi_module.c linux-2.6.6/drivers/scsi/scsi_module.c
--- linux-2.6.6/drivers/scsi.org/scsi_module.c	2004-05-10 04:32:26.000000000 +0200
+++ linux-2.6.6/drivers/scsi/scsi_module.c	2004-05-12 17:46:22.935157160 +0200
@@ -12,7 +12,7 @@
 #include <linux/module.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 
 static int __init init_this_scsi_driver(void)
diff -purN linux-2.6.6/drivers/scsi.org/scsi_pc98.c linux-2.6.6/drivers/scsi/scsi_pc98.c
--- linux-2.6.6/drivers/scsi.org/scsi_pc98.c	2004-05-10 04:31:59.000000000 +0200
+++ linux-2.6.6/drivers/scsi/scsi_pc98.c	2004-05-12 17:46:22.939156552 +0200
@@ -12,7 +12,7 @@
 #include <asm/pc9800.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 
 static int pc98_first_bios_param(struct scsi_device *sdev, int *ip)
diff -purN linux-2.6.6/drivers/scsi.org/sd.c linux-2.6.6/drivers/scsi/sd.c
--- linux-2.6.6/drivers/scsi.org/sd.c	2004-05-12 17:45:58.180920000 +0200
+++ linux-2.6.6/drivers/scsi/sd.c	2004-05-12 17:46:23.040141200 +0200
@@ -52,7 +52,7 @@
 #include <asm/uaccess.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
diff -purN linux-2.6.6/drivers/scsi.org/seagate.c linux-2.6.6/drivers/scsi/seagate.c
--- linux-2.6.6/drivers/scsi.org/seagate.c	2004-05-10 04:32:29.000000000 +0200
+++ linux-2.6.6/drivers/scsi/seagate.c	2004-05-12 17:46:23.069136792 +0200
@@ -103,7 +103,7 @@
 #include <asm/uaccess.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "seagate.h"
 
 #include <scsi/scsi_ioctl.h>
diff -purN linux-2.6.6/drivers/scsi.org/sg.c linux-2.6.6/drivers/scsi/sg.c
--- linux-2.6.6/drivers/scsi.org/sg.c	2004-05-10 04:32:29.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sg.c	2004-05-12 17:46:23.118129344 +0200
@@ -60,7 +60,7 @@ static int sg_version_num = 30530;	/* 2 
 
 #include <linux/blkdev.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
diff -purN linux-2.6.6/drivers/scsi.org/sgiwd93.c linux-2.6.6/drivers/scsi/sgiwd93.c
--- linux-2.6.6/drivers/scsi.org/sgiwd93.c	2004-05-12 17:45:58.182920000 +0200
+++ linux-2.6.6/drivers/scsi/sgiwd93.c	2004-05-12 17:46:23.127127976 +0200
@@ -31,7 +31,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "sgiwd93.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/sim710.c linux-2.6.6/drivers/scsi/sim710.c
--- linux-2.6.6/drivers/scsi.org/sim710.c	2004-05-10 04:33:13.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sim710.c	2004-05-12 17:46:23.136126608 +0200
@@ -37,7 +37,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "53c700.h"
 
 
diff -purN linux-2.6.6/drivers/scsi.org/sr.c linux-2.6.6/drivers/scsi/sr.c
--- linux-2.6.6/drivers/scsi.org/sr.c	2004-05-12 17:45:58.184919000 +0200
+++ linux-2.6.6/drivers/scsi/sr.c	2004-05-12 17:46:23.154123872 +0200
@@ -47,7 +47,7 @@
 #include <asm/uaccess.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
diff -purN linux-2.6.6/drivers/scsi.org/sr_ioctl.c linux-2.6.6/drivers/scsi/sr_ioctl.c
--- linux-2.6.6/drivers/scsi.org/sr_ioctl.c	2004-05-10 04:32:52.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sr_ioctl.c	2004-05-12 17:46:23.166122048 +0200
@@ -11,7 +11,7 @@
 #include <asm/uaccess.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 
 #include "sr.h"
diff -purN linux-2.6.6/drivers/scsi.org/sr_vendor.c linux-2.6.6/drivers/scsi/sr_vendor.c
--- linux-2.6.6/drivers/scsi.org/sr_vendor.c	2004-05-10 04:32:29.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sr_vendor.c	2004-05-12 17:46:23.174120832 +0200
@@ -41,7 +41,7 @@
 
 #include <linux/blkdev.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 
 #include <linux/cdrom.h>
diff -purN linux-2.6.6/drivers/scsi.org/st.c linux-2.6.6/drivers/scsi/st.c
--- linux-2.6.6/drivers/scsi.org/st.c	2004-05-12 17:45:58.190918000 +0200
+++ linux-2.6.6/drivers/scsi/st.c	2004-05-12 17:46:23.242110496 +0200
@@ -58,7 +58,7 @@ static char *verstr = "20040403";
 
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
diff -purN linux-2.6.6/drivers/scsi.org/sun3_scsi.c linux-2.6.6/drivers/scsi/sun3_scsi.c
--- linux-2.6.6/drivers/scsi.org/sun3_scsi.c	2004-05-10 04:32:00.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sun3_scsi.c	2004-05-12 17:46:23.304101072 +0200
@@ -75,7 +75,7 @@
 #define REAL_DMA
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 #include "NCR5380.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/sun3_scsi_vme.c linux-2.6.6/drivers/scsi/sun3_scsi_vme.c
--- linux-2.6.6/drivers/scsi.org/sun3_scsi_vme.c	2004-05-10 04:33:22.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sun3_scsi_vme.c	2004-05-12 17:46:23.316099248 +0200
@@ -41,7 +41,7 @@
 #define REAL_DMA
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "sun3_scsi.h"
 #include "NCR5380.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/sun3x_esp.c linux-2.6.6/drivers/scsi/sun3x_esp.c
--- linux-2.6.6/drivers/scsi.org/sun3x_esp.c	2004-05-10 04:32:54.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sun3x_esp.c	2004-05-12 17:46:23.326097728 +0200
@@ -16,7 +16,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "NCR53C9x.h"
 
 #include <asm/sun3x.h>
diff -purN linux-2.6.6/drivers/scsi.org/sym53c416.c linux-2.6.6/drivers/scsi/sym53c416.c
--- linux-2.6.6/drivers/scsi.org/sym53c416.c	2004-05-10 04:32:01.000000000 +0200
+++ linux-2.6.6/drivers/scsi/sym53c416.c	2004-05-12 17:46:23.342095296 +0200
@@ -43,7 +43,7 @@
 #include <linux/blkdev.h>
 #include <linux/isapnp.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "sym53c416.h"
 
 #define VERSION_STRING        "Version 1.0.0-ac"
diff -purN linux-2.6.6/drivers/scsi.org/t128.c linux-2.6.6/drivers/scsi/t128.c
--- linux-2.6.6/drivers/scsi.org/t128.c	2004-05-10 04:33:19.000000000 +0200
+++ linux-2.6.6/drivers/scsi/t128.c	2004-05-12 17:46:23.352093776 +0200
@@ -118,7 +118,7 @@
 #include <linux/delay.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "t128.h"
 #define AUTOPROBE_IRQ
 #include "NCR5380.h"
diff -purN linux-2.6.6/drivers/scsi.org/tmscsim.c linux-2.6.6/drivers/scsi/tmscsim.c
--- linux-2.6.6/drivers/scsi.org/tmscsim.c	2004-05-10 04:33:22.000000000 +0200
+++ linux-2.6.6/drivers/scsi/tmscsim.c	2004-05-12 17:46:23.401086328 +0200
@@ -235,7 +235,7 @@
 #include <linux/interrupt.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <linux/stat.h>
 #include <scsi/scsicam.h>
 
diff -purN linux-2.6.6/drivers/scsi.org/u14-34f.c linux-2.6.6/drivers/scsi/u14-34f.c
--- linux-2.6.6/drivers/scsi.org/u14-34f.c	2004-05-10 04:32:27.000000000 +0200
+++ linux-2.6.6/drivers/scsi/u14-34f.c	2004-05-12 17:46:23.435081160 +0200
@@ -423,7 +423,7 @@
 #include <linux/spinlock.h>
 #include <scsi/scsicam.h>
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 
diff -purN linux-2.6.6/drivers/scsi.org/ultrastor.c linux-2.6.6/drivers/scsi/ultrastor.c
--- linux-2.6.6/drivers/scsi.org/ultrastor.c	2004-05-10 04:32:37.000000000 +0200
+++ linux-2.6.6/drivers/scsi/ultrastor.c	2004-05-12 17:46:23.457077816 +0200
@@ -145,7 +145,7 @@
 
 #define ULTRASTOR_PRIVATE	/* Get the private stuff from ultrastor.h */
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include "ultrastor.h"
 
 #define FALSE 0
diff -purN linux-2.6.6/drivers/scsi.org/wd33c93.c linux-2.6.6/drivers/scsi/wd33c93.c
--- linux-2.6.6/drivers/scsi.org/wd33c93.c	2004-05-10 04:32:53.000000000 +0200
+++ linux-2.6.6/drivers/scsi/wd33c93.c	2004-05-12 17:46:23.491072648 +0200
@@ -83,7 +83,7 @@
 #include <asm/irq.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "wd33c93.h"
 
diff -purN linux-2.6.6/drivers/scsi.org/wd7000.c linux-2.6.6/drivers/scsi/wd7000.c
--- linux-2.6.6/drivers/scsi.org/wd7000.c	2004-05-10 04:33:21.000000000 +0200
+++ linux-2.6.6/drivers/scsi/wd7000.c	2004-05-12 17:46:23.521068088 +0200
@@ -183,7 +183,7 @@
 #include <asm/io.h>
 
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
 
diff -purN linux-2.6.6/drivers/scsi.org/zalon.c linux-2.6.6/drivers/scsi/zalon.c
--- linux-2.6.6/drivers/scsi.org/zalon.c	2004-05-10 04:32:53.000000000 +0200
+++ linux-2.6.6/drivers/scsi/zalon.c	2004-05-12 17:46:23.528067024 +0200
@@ -24,7 +24,7 @@
 
 #include "../parisc/gsc.h"
 #include "scsi.h"
-#include "hosts.h"
+#include <scsi/scsi_host.h>
 
 #include "ncr53c8xx.h"
 
 
--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAuasPxULwo51rQBIRAnfjAJ9xDpkiB0ynLIm4/4aK5lHX329XfACgoHfg
wJ3dRl1FjdydCFQkR+GIdtc=
=5ZbQ
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
