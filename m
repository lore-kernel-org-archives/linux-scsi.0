From: Alan Stern <stern@rowland.harvard.edu>
Subject: Trivial patch for scsi logging text string
Date: Tue, 15 Apr 2003 11:01:31 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304151059460.1036-100000@ida.rowland.org>
References: <20030415063303.GC1366@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20228 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261649AbTDOOtk
	(for <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2003 10:49:40 -0400
In-Reply-To: <20030415063303.GC1366@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org

Greg:

This patch fixes a very minor bobble in a kernel logging string (excess 
blank space following the \n).  Please apply.

Alan Stern

--- 1.34/drivers/scsi/scsi_lib.c	Mon Apr  7 06:33:23 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Apr 15 10:58:22 2003
@@ -703,7 +703,7 @@
 	if (good_sectors >= 0) {
 		SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, %d sectors done.\n",
 					      req->nr_sectors, good_sectors));
-		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n ", cmd->use_sg));
+		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 		if (clear_errors)
 			req->errors = 0;

