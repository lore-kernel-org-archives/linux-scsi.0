From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] some left highmem_io instances
Date: Tue, 5 Aug 2003 13:46:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030805114653.GA24015@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:53163 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S272674AbTHELq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2003 07:46:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.40/drivers/ieee1394/sbp2.c	Sat Jul  5 21:42:23 2003
+++ edited/drivers/ieee1394/sbp2.c	Sun Aug  3 05:01:38 2003
@@ -2881,7 +2881,6 @@
 	.cmd_per_lun =			SBP2_MAX_CMDS_PER_LUN,
 	.can_queue = 			SBP2_MAX_SCSI_QUEUE,
 	.emulated =			1,
-	.highmem_io =			1,
 };
 
 static int sbp2_module_init(void)
--- 1.25/drivers/message/fusion/mptscsih.c	Fri May  2 19:56:19 2003
+++ edited/drivers/message/fusion/mptscsih.c	Tue Aug  5 04:00:12 2003
@@ -1458,7 +1458,6 @@
 				sh->max_lun = MPT_LAST_LUN + 1;
 
 				sh->max_sectors = MPT_SCSI_MAX_SECTORS;
-				sh->highmem_io = 1;
 				sh->this_id = this->pfacts[portnum].PortSCSIID;
 
 				/* Required entry.
