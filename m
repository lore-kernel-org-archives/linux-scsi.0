From: John Levon <levon@movementarian.org>
Subject: [PATCH] NCR5380 typos
Date: Wed, 26 Feb 2003 19:25:52 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226192552.GC58846@compsoc.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compsoc.umu.man.ac.uk
	([130.88.22.5] helo=mrtall.compsoc.man.ac.uk ident=exim)
	by probity.mcc.ac.uk with esmtp (Exim 4.12)
	id 18o7Bh-000EpW-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:25:53 +0000
Received: from moz by mrtall.compsoc.man.ac.uk with local (Exim 3.33 #1)
	id 18o7Bg-000FUm-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:25:52 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Against 2.5.63, untested

regards
john



--- linux-linus/drivers/scsi/NCR5380.c	2003-02-10 19:21:41.000000000 +0000
+++ linux/drivers/scsi/NCR5380.c	2003-02-26 19:28:29.000000000 +0000
@@ -2750,7 +2750,7 @@
 	phase = PHASE_MSGIN;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
 
-	if (!msg[0] & 0x80) {
+	if (!(msg[0] & 0x80)) {
 		printk(KERN_ERR "scsi%d : expecting IDENTIFY message, got ", instance->host_no);
 		print_msg(msg);
 		abort = 1;
--- linux-linus/drivers/scsi/atari_NCR5380.c	2003-01-03 03:06:43.000000000 +0000
+++ linux/drivers/scsi/atari_NCR5380.c	2003-02-26 19:31:02.000000000 +0000
@@ -2543,7 +2543,7 @@
     phase = PHASE_MSGIN;
     NCR5380_transfer_pio(instance, &phase, &len, &data);
 
-    if (!msg[0] & 0x80) {
+    if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
 	print_msg(msg);
 	do_abort(instance);
--- linux-linus/drivers/scsi/mac_NCR5380.c	2003-01-03 03:06:43.000000000 +0000
+++ linux/drivers/scsi/mac_NCR5380.c	2003-02-26 19:31:15.000000000 +0000
@@ -2694,7 +2694,7 @@
     phase = PHASE_MSGIN;
     NCR5380_transfer_pio(instance, &phase, &len, &data);
 
-    if (!msg[0] & 0x80) {
+    if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
 	print_msg(msg);
 	do_abort(instance);
