From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] constants.c codingstyle fixes
Date: Tue, 3 Jun 2003 23:04:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030603210427.GA9336@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:14505 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261166AbTFCUvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2003 16:51:02 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is the same procedure most of the scsi source files
got a while ago.


diff -Nru a/drivers/scsi/constants.c b/drivers/scsi/constants.c
--- a/drivers/scsi/constants.c	Sun Jun  1 21:27:22 2003
+++ b/drivers/scsi/constants.c	Sun Jun  1 21:27:22 2003
@@ -1004,16 +1004,14 @@
 #endif
 }
 
-void print_sense(const char * devclass, Scsi_Cmnd * SCpnt)
+void print_sense(const char *devclass, struct scsi_cmnd *cmd)
 {
-	print_sense_internal(devclass, SCpnt->sense_buffer,
-			     SCpnt->request);
+	print_sense_internal(devclass, cmd->sense_buffer, cmd->request);
 }
 
-void print_req_sense(const char * devclass, Scsi_Request * SRpnt)
+void print_req_sense(const char *devclass, struct scsi_request *sreq)
 {
-	print_sense_internal(devclass, SRpnt->sr_sense_buffer,
-			     SRpnt->sr_request);
+	print_sense_internal(devclass, sreq->sr_sense_buffer, sreq->sr_request);
 }
 
 #if (CONSTANTS & CONST_MSG) 
@@ -1116,13 +1114,13 @@
     return len;
 }
 
-void print_Scsi_Cmnd (Scsi_Cmnd *cmd) {
+void print_Scsi_Cmnd(struct scsi_cmnd *cmd) {
     printk("scsi%d : destination target %d, lun %d\n", 
 	   cmd->device->host->host_no, 
 	   cmd->device->id, 
 	   cmd->device->lun);
     printk("        command = ");
-    print_command (cmd->cmnd);
+    print_command(cmd->cmnd);
 }
 
 #if (CONSTANTS & CONST_HOST)
