From: John Levon <levon@movementarian.org>
Subject: [PATCH] sun3_NCR typo
Date: Wed, 26 Feb 2003 19:17:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226191723.GA58644@compsoc.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compsoc.umu.man.ac.uk
	([130.88.22.5] helo=mrtall.compsoc.man.ac.uk ident=exim)
	by serenity.mcc.ac.uk with esmtp (Exim 4.12)
	id 18o73T-000E3s-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:17:23 +0000
Received: from moz by mrtall.compsoc.man.ac.uk with local (Exim 3.33 #1)
	id 18o73T-000FGX-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:17:23 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Untested, 2.5.63


--- linux-linus/drivers/scsi/sun3_NCR5380.c	2003-01-03 03:06:44.000000000 +0000
+++ linux/drivers/scsi/sun3_NCR5380.c	2003-02-26 19:22:29.000000000 +0000
@@ -2564,7 +2564,7 @@
     msg[0] = NCR5380_read(CURRENT_SCSI_DATA_REG);
 #endif
 
-    if (!msg[0] & 0x80) {
+    if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
 	print_msg(msg);
 	do_abort(instance);
