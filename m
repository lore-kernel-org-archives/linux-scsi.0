From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH] missing include for sim710
Date: Tue, 11 Feb 2003 13:34:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302111334.56193@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

--- linux-2.5.60/drivers/scsi/sim710.c	Mon Feb 10 19:38:49 2003
+++ linux-2.5.60-eike/drivers/scsi/sim710.c	Tue Feb 11 13:32:29 2003
@@ -32,6 +32,7 @@
 #include <linux/blk.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #ifdef CONFIG_MCA
 #include <linux/mca.h>
 #endif
@@ -129,7 +130,7 @@
 {
 	struct Scsi_Host * host = NULL;
 	struct NCR_700_Host_Parameters *hostdata =
-		kmalloc(sizeof(struct NCR_700_Host_Parameters),	GFP_KERNEL);
+		kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
 
 	printk(KERN_NOTICE "sim710: %s\n", dev->name);
 	printk(KERN_NOTICE "sim710: irq = %d, clock = %d, base = 0x%lx, scsi_id = %d\n",
