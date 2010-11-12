From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 10/11] mpt2sas: Debug string changes from target to device.
Date: Sat, 13 Nov 2010 04:41:32 +0530
Message-ID: <20101112231126.GL853@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:56002 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933008Ab0KLXx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 18:53:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Changing debug print to correct string.


Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 900a367..2a1776a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2274,13 +2274,13 @@ _scsih_dev_reset(struct scsi_cmnd *scmd)
 
 	struct scsi_target *starget = scmd->device->sdev_target;
 
-	starget_printk(KERN_INFO, starget, "attempting target reset! "
+	starget_printk(KERN_INFO, starget, "attempting device reset! "
 	    "scmd(%p)\n", scmd);
 	_scsih_tm_display_info(ioc, scmd);
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
-		starget_printk(KERN_INFO, starget, "target been deleted! "
+		starget_printk(KERN_INFO, starget, "device been deleted! "
 		    "scmd(%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
