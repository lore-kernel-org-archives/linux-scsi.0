From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2.5.62] kill unneeded includes in NCR_D700.c
Date: Tue, 18 Feb 2003 13:32:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302181332.40148@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

diff -Naur linux-2.5.62/drivers/scsi/NCR_D700.c linux-2.5.62-eike/drivers/scsi/NCR_D700.c
--- linux-2.5.62/drivers/scsi/NCR_D700.c	Mon Feb 17 23:55:56 2003
+++ linux-2.5.62-eike/drivers/scsi/NCR_D700.c	Tue Feb 18 13:00:49 2003
@@ -95,17 +95,8 @@
 #include <linux/config.h>
 #include <linux/blk.h>
 #include <linux/interrupt.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/spinlock.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-#include <linux/proc_fs.h>
-#include <linux/init.h>
-#include <linux/device.h>
 #include <linux/mca.h>
 
 #include <asm/dma.h>
