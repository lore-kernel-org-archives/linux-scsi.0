From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove SCSI_STATE_ #defines
Date: Fri, 4 Aug 2006 17:18:30 +0200
Message-ID: <20060804151830.GA29630@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:57285 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932421AbWHDPSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2006 11:18:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

These aren't used anymore since the field in scsi_cmnd where it was
stored has been removed.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_cmnd.h	2006-07-26 09:37:44.000000000 +0200
+++ linux-2.6/include/scsi/scsi_cmnd.h	2006-07-26 10:36:32.000000000 +0200
@@ -118,20 +118,6 @@
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
 };
 
-/*
- * These are the values that scsi_cmd->state can take.
- */
-#define SCSI_STATE_TIMEOUT         0x1000
-#define SCSI_STATE_FINISHED        0x1001
-#define SCSI_STATE_FAILED          0x1002
-#define SCSI_STATE_QUEUED          0x1003
-#define SCSI_STATE_UNUSED          0x1006
-#define SCSI_STATE_DISCONNECTING   0x1008
-#define SCSI_STATE_INITIALIZING    0x1009
-#define SCSI_STATE_BHQUEUE         0x100a
-#define SCSI_STATE_MLQUEUE         0x100b
-
-
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
