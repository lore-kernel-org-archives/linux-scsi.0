From: akpm@osdl.org
Subject: [patch 26/28] scsi: included header cleanup
Date: Mon, 25 Sep 2006 16:59:12 -0700
Message-ID: <200609252359.k8PNxC5o003541@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:49851 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751767AbWIYX7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Free seagate.h from obsolete drivers/scsi.h, remove a double inclusion od
linux/delay.h and remove the unneeded scsi/scsi_ioctl.h

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/seagate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/seagate.c~scsi-included-header-cleanup drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c~scsi-included-header-cleanup
+++ a/drivers/scsi/seagate.c
@@ -94,7 +94,6 @@
 #include <linux/string.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
-#include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/stat.h>
 #include <linux/delay.h>
@@ -103,11 +102,13 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 
-#include "scsi.h"
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi.h>
+
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 
-#include <scsi/scsi_ioctl.h>
 
 #ifdef DEBUG
 #define DPRINTK( when, msg... ) do { if ( (DEBUG & (when)) == (when) ) printk( msg ); } while (0)
_
