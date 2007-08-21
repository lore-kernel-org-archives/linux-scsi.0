From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [RFC][PATCH] Removal of #include <linux/stat.h> from scsi drivers
Date: Tue, 21 Aug 2007 20:01:09 +0200
Message-ID: <46CB2865.3030103@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:55193 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760779AbXHUSBt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2007 14:01:49 -0400
Received: by an-out-0708.google.com with SMTP id d31so163020and
        for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 11:01:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Hi,

This patch removes linux/stat.h from scsi drivers.

Tested with allyesconfig and allmodconfig.

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 9b20617..8e91c6f 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -37,7 +37,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/mm.h>
-#include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 79b4df1..5f38364 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -31,7 +31,6 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index eda8c48..aa4109a 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -43,7 +43,6 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <asm/io.h>
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index b7c5385..6f356b9 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -18,8 +18,6 @@
 #include "wd33c93.h"
 #include "a2091.h"
 
-#include<linux/stat.h>
-
 #define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 796f1c4..8bec5fd 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -18,8 +18,6 @@
 #include "wd33c93.h"
 #include "a3000.h"
 
-#include<linux/stat.h>
-
 #define DMA(ptr) ((a3000_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index cbbfbc9..fdcb65a 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -77,8 +77,6 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
 	panic("Buffer at physical address > 16Mb used for aha1542");
 }
 
-#include<linux/stat.h>
-
 #ifdef DEBUG
 #define DEB(x) x
 #else
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index e4a4f3a..f8f7110 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -45,7 +45,6 @@
 #include <linux/string.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/eisa.h>
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 1a71b02..8efcd73 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -245,7 +245,6 @@
 #include "aic7xxx_old/aic7xxx_reg.h"
 #include <scsi/scsicam.h>
 
-#include <linux/stat.h>
 #include <linux/slab.h>        /* for kmalloc() */
 
 #define AIC7XXX_C_VERSION  "5.2.6"
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2836fe2..b3cf425 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -25,7 +25,6 @@
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
 #include <linux/unistd.h>
-#include <linux/stat.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 6f8403b..279e0cc 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -107,8 +107,6 @@
 #include <asm/atari_stram.h>
 #include <asm/io.h>
 
-#include <linux/stat.h>
-
 #define	IS_A_TT()	ATARIHW_PRESENT(TT_SCSI)
 
 #define	SCSI_DMA_WRITE_P(elt,val)				\
diff --git a/drivers/scsi/blz1230.c b/drivers/scsi/blz1230.c
index 23f7c24..5ea6306 100644
--- a/drivers/scsi/blz1230.c
+++ b/drivers/scsi/blz1230.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/interrupt.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/blz2060.c b/drivers/scsi/blz2060.c
index b6203ec..bba1ec8 100644
--- a/drivers/scsi/blz2060.c
+++ b/drivers/scsi/blz2060.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/interrupt.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/cyberstorm.c b/drivers/scsi/cyberstorm.c
index c6b98a4..cf7b0bc 100644
--- a/drivers/scsi/cyberstorm.c
+++ b/drivers/scsi/cyberstorm.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/interrupt.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/cyberstormII.c b/drivers/scsi/cyberstormII.c
index e336e85..44421a1 100644
--- a/drivers/scsi/cyberstormII.c
+++ b/drivers/scsi/cyberstormII.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/interrupt.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/dec_esp.c b/drivers/scsi/dec_esp.c
index d42ad66..000ba4b 100644
--- a/drivers/scsi/dec_esp.c
+++ b/drivers/scsi/dec_esp.c
@@ -29,7 +29,6 @@
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 #include <linux/tc.h>
 
 #include <asm/dma.h>
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 9d7bdf7..95eb9b8 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -44,7 +44,6 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
 #include <linux/ioctl.h>	/* For SCSI-Passthrough */
 #include <asm/uaccess.h>
 
-#include <linux/stat.h>
 #include <linux/slab.h>		/* for kmalloc() */
 #include <linux/pci.h>		/* for PCI support */
 #include <linux/proc_fs.h>
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index da7409e..05a3e8d 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -77,7 +77,6 @@
 #include <linux/signal.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
-#include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index a83e9f1..0d913cf 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -484,7 +484,6 @@
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
-#include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
diff --git a/drivers/scsi/fastlane.c b/drivers/scsi/fastlane.c
index 4266a21..d178a52 100644
--- a/drivers/scsi/fastlane.c
+++ b/drivers/scsi/fastlane.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/interrupt.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/fcal.c b/drivers/scsi/fcal.c
index c4e16c0..8bf507f 100644
--- a/drivers/scsi/fcal.c
+++ b/drivers/scsi/fcal.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 36169d5..8a9e424 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -276,7 +276,6 @@
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
 #include <linux/pci.h>
-#include <linux/stat.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <scsi/scsicam.h>
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 607336f..df5295f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -108,7 +108,6 @@
 #include <scsi/scsi_host.h>
 #include "g_NCR5380.h"
 #include "NCR5380.h"
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/isapnp.h>
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 37741e9..fc7230d 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -18,8 +18,6 @@
 #include "wd33c93.h"
 #include "gvp11.h"
 
-#include<linux/stat.h>
-
 #define DMA(ptr) ((gvp11_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4275d1b..9d92caf 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -27,7 +27,6 @@
 #include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/mca.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/imm.h b/drivers/scsi/imm.h
index 8f6f32f..a5549d3 100644
--- a/drivers/scsi/imm.h
+++ b/drivers/scsi/imm.h
@@ -72,7 +72,6 @@
 #include  <linux/ioport.h>
 #include  <linux/delay.h>
 #include  <linux/proc_fs.h>
-#include  <linux/stat.h>
 #include  <linux/blkdev.h>
 #include  <linux/sched.h>
 #include  <linux/interrupt.h>
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 312190a..ebdedc9 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -120,7 +120,6 @@
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
 #include <linux/ioport.h>
-#include <linux/stat.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index d9dfb69..f09ee0a 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -86,7 +86,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/string.h>
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index b17771b..2c23594 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -189,8 +189,6 @@
 
 #include <linux/module.h>
 
-#include <linux/stat.h>
-
 #include <linux/spinlock.h>
 #include <linux/init.h>
 
diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 3126824..1d2b664 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -35,7 +35,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/stat.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
 #include <linux/ioport.h>
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index b12ad7c..d533de9 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <asm/dbdma.h>
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index bcb4902..cb3dd68 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 
diff --git a/drivers/scsi/mca_53c9x.c b/drivers/scsi/mca_53c9x.c
index d693d0f..32b4a6d 100644
--- a/drivers/scsi/mca_53c9x.c
+++ b/drivers/scsi/mca_53c9x.c
@@ -39,7 +39,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/mca-legacy.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 651d09b..61290dc 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index be41aad..815a465 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -13,8 +13,6 @@
 #include "wd33c93.h"
 #include "mvme147.h"
 
-#include<linux/stat.h>
-
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static struct Scsi_Host *mvme147_host = NULL;
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 030ba49..172925f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -106,7 +106,6 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/time.h>
 #include <linux/timer.h>
diff --git a/drivers/scsi/oktagon_esp.c b/drivers/scsi/oktagon_esp.c
index 26a6d55..5cb8c03 100644
--- a/drivers/scsi/oktagon_esp.c
+++ b/drivers/scsi/oktagon_esp.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/reboot.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index ee59656..1142027 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -121,7 +121,6 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 445cfbb..1c96680 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -39,7 +39,6 @@
 #include <linux/interrupt.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <linux/stat.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/scsi/pluto.c b/drivers/scsi/pluto.c
index e221389..c3ad352 100644
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
diff --git a/drivers/scsi/ppa.h b/drivers/scsi/ppa.h
index ba80214..a23b70c 100644
--- a/drivers/scsi/ppa.h
+++ b/drivers/scsi/ppa.h
@@ -79,7 +79,6 @@
 #include  <linux/ioport.h>
 #include  <linux/delay.h>
 #include  <linux/proc_fs.h>
-#include  <linux/stat.h>
 #include  <linux/blkdev.h>
 #include  <linux/sched.h>
 #include  <linux/interrupt.h>
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 899e89d..eaea76e 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -35,7 +35,6 @@
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 
 #include <asm/dma.h>
 #include <asm/system.h>
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 54d8bdf..9e3d6f1 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -343,7 +343,6 @@
 #include <linux/timer.h>
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/pci_ids.h>
 #include <linux/interrupt.h>
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 94baca8..156bea6 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -25,7 +25,6 @@
 #include <linux/proc_fs.h>
 #include <linux/unistd.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 2bfbf26..ad0d990 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -49,7 +49,6 @@
 #include <linux/proc_fs.h>
 #include <linux/unistd.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 5948872..08bc878 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4947dfe..baf562a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -44,8 +44,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
-#include <linux/stat.h>
-
 #include "scsi_logging.h"
 #include "scsi_debug.h"
 
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index ce80fa9..5a85b53 100644
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -95,7 +95,6 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-#include <linux/stat.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 0a6b45b..d84dc5e 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/stat.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
 #include <linux/sched.h>
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 80fb3f8..77108aa 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/proc_fs.h>
-#include <linux/stat.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 248d60b..a29245b 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -111,7 +111,6 @@
 #include <linux/io.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
-#include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 9e8232a..5da43d1 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -415,7 +415,6 @@
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
-#include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index c08235d..2a08710 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -136,7 +136,6 @@
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 #include <linux/bitops.h>
 
 #include <asm/io.h>
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index d6fd425..82a963c 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -177,7 +177,6 @@
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
-#include <linux/stat.h>
 #include <linux/io.h>
 
 #include <asm/system.h>
