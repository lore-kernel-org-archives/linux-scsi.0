From: John Levon <levon@movementarian.org>
Subject: [PATCH] AM53C974 typo
Date: Wed, 26 Feb 2003 19:27:39 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226192739.GD58846@compsoc.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compsoc.umu.man.ac.uk
	([130.88.22.5] helo=mrtall.compsoc.man.ac.uk ident=exim)
	by serenity.mcc.ac.uk with esmtp (Exim 4.12)
	id 18o7DP-000EVZ-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:27:39 +0000
Received: from moz by mrtall.compsoc.man.ac.uk with local (Exim 3.33 #1)
	id 18o7DP-000FWB-00
	for linux-scsi@vger.kernel.org; Wed, 26 Feb 2003 19:27:39 +0000
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Against 2.5.63, untested

regards
john

--- linux-linus/drivers/scsi/AM53C974.c	2003-02-25 13:53:54.000000000 +0000
+++ linux/drivers/scsi/AM53C974.c	2003-02-26 19:32:42.000000000 +0000
@@ -2091,7 +2091,7 @@
 		goto EXIT_ABORT;
 	}
 	msg[0] = AM53C974_read_8(FFREG);
-	if (!msg[0] & 0x80) {
+	if (!(msg[0] & 0x80)) {
 		printk("scsi%d: error: expecting IDENTIFY message, got ", instance->host_no);
 		print_msg(msg);
 		hostdata->aborted = 1;
