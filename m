From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] (7/27) *really* dumb typo in aacraid (cast to pointer to structure that doesn't exist ;-)
Date: Wed, 2 Feb 2005 19:13:40 +0000
Message-ID: <20050202191340.GD8859@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36807 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262896AbVBBTNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2005 14:13:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	spot the typo...  It's harmless, in a sense that code compiles right,
but...
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC11-rc2-bk10-rme9652/drivers/scsi/aacraid/aachba.c RC11-rc2-bk10-aacraid/drivers/scsi/aacraid/aachba.c
--- RC11-rc2-bk10-rme9652/drivers/scsi/aacraid/aachba.c	Tue Feb  1 21:44:42 2005
+++ RC11-rc2-bk10-aacraid/drivers/scsi/aacraid/aachba.c	Wed Feb  2 08:12:13 2005
@@ -1047,7 +1047,7 @@
 			COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 	else {
 		struct scsi_device *sdev = cmd->device;
-		struct aac_dev *dev = (struct aav_dev *)sdev->host->hostdata;
+		struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
 		u32 cid = ID_LUN_TO_CONTAINER(sdev->id, sdev->lun);
 		printk(KERN_WARNING 
 		     "synchronize_callback: synchronize failed, status = %d\n",
