From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] nuke some superflous externs
Date: Sun, 27 Apr 2003 17:50:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427175056.A29923@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:41485 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S264677AbTD0Pio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 11:38:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

No idea why those were ever added to scsi.c and scsi_syms.c, they're
properly declared in the headers.


--- 1.105/drivers/scsi/scsi.c	Sat Apr 26 14:36:16 2003
+++ edited/drivers/scsi/scsi.c	Sun Apr 27 13:58:46 2003
@@ -115,11 +118,6 @@
 static unsigned scsi_default_dev_flags;
 LIST_HEAD(scsi_dev_info_list);
 
-/* 
- * Function prototypes.
- */
-extern void scsi_times_out(struct scsi_cmnd *cmd);
-
 MODULE_PARM(scsi_logging_level, "i");
 MODULE_PARM_DESC(scsi_logging_level, "SCSI logging level; should be zero or nonzero");
 
--- 1.31/drivers/scsi/scsi_syms.c	Mon Apr 21 06:10:29 2003
+++ edited/drivers/scsi/scsi_syms.c	Sun Apr 27 09:19:20 2003
@@ -104,8 +102,6 @@
 /*
  * Externalize timers so that HBAs can safely start/restart commands.
  */
-extern void scsi_add_timer(Scsi_Cmnd *, int, void ((*) (Scsi_Cmnd *)));
-extern int scsi_delete_timer(Scsi_Cmnd *);
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
 
