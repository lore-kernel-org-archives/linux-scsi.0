From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 1/4] sd: fix cache flushing message
Date: Wed, 29 Apr 2009 22:06:28 +0200
Message-ID: <200904292206.29844.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:60746 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZD2UHS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 16:07:18 -0400
Received: by bwz7 with SMTP id 7so1401144bwz.37
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2009 13:07:16 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
some minor sd.c fixups against linux-next

 drivers/scsi/sd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/sd.c
===================================================================
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2140,7 +2140,7 @@ static void sd_shutdown(struct device *d
 		return;         /* this can happen */
 
 	if (sdkp->WCE) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
 		sd_sync_cache(sdkp);
 	}
 
@@ -2161,7 +2161,7 @@ static int sd_suspend(struct device *dev
 		return 0;	/* this can happen */
 
 	if (sdkp->WCE) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
 		ret = sd_sync_cache(sdkp);
 		if (ret)
 			goto done;
