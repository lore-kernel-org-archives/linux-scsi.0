From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] aic79xxx_osm.c in 2.5.59-bk3
Date: Mon, 10 Feb 2003 09:17:15 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E46D36B.2070901@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000809040304010906040400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-59.triode.net.au [202.147.125.59])
	by iggy.triode.net.au (8.12.7/8.12.7) with ESMTP id h19MF8Ik018412
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2003 09:15:09 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000809040304010906040400
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I needed the attachment to compile this file in lk 2.5.59-bk3.
Unfortunately I don't have the hardware to test it.

Doug Gilbert

--------------000809040304010906040400
Content-Type: text/plain;
 name="aic79xx_osm_2559bk3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx_osm_2559bk3.diff"

--- linux/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-02-10 08:56:24.000000000 +1100
+++ linux/drivers/scsi/aic7xxx/aic79xx_osm.c2559bk3fix	2003-02-10 09:11:17.000000000 +1100
@@ -1560,7 +1560,7 @@
 	hscb = scb->hscb;
 	hscb->control = 0;
 	hscb->scsiid = BUILD_SCSIID(ahd, cmd);
-	hscb->lun = cmd->lun;
+	hscb->lun = cmd->device->lun;
 	hscb->cdb_len = 0;
 	hscb->task_management = SIU_TASKMGMT_LUN_RESET;
 	scb->flags |= SCB_DEVICE_RESET|SCB_RECOVERY_SCB|SCB_ACTIVE;

--------------000809040304010906040400--

