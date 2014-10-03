From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi_debug: Error message should say scsi_host_alloc not
 scsi_register
Date: Fri, 3 Oct 2014 11:43:31 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1410011653220.25690@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38963 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaJCBoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 21:44:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, trivial@kernel.org


Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/scsi_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/scsi_debug.c
===================================================================
--- linux.orig/drivers/scsi/scsi_debug.c	2014-09-29 10:55:44.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c	2014-10-01 16:33:23.000000000 +1000
@@ -3967,7 +3967,7 @@ static int sdebug_driver_probe(struct de
 		sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
 	hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
 	if (NULL == hpnt) {
-		printk(KERN_ERR "%s: scsi_register failed\n", __func__);
+		pr_err("%s: scsi_host_alloc failed\n", __func__);
 		error = -ENODEV;
 		return error;
 	}
