From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi: remove obsolete comment in scsi_devinfo.c
Date: Sat, 13 Aug 2016 17:09:49 +0200
Message-ID: <1471100989-4804-1-git-send-email-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36361 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbcHMPJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2016 11:09:53 -0400
Received: by mail-wm0-f66.google.com with SMTP id i138so2719886wmf.3
        for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2016 08:09:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>

Unrealistic wish, maybe for next Christmas with the pony.
And highlight "unused" comment at revision.

Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 2464569..2d4bd7b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -43,14 +43,11 @@ static char scsi_dev_flags[256];
  * settings that differ from the default, includes black-listed (broken)
  * devices. The entries here are added to the tail of scsi_dev_info_list
  * via scsi_dev_info_list_init.
- *
- * Do not add to this list, use the command line or proc interface to add
- * to the scsi_dev_info_list. This table will eventually go away.
  */
 static struct {
 	char *vendor;
 	char *model;
-	char *revision;	/* revision known to be bad, unused */
+	char *revision;	/* XXX revision known to be bad, unused XXX */
 	unsigned flags;
 } scsi_static_device_list[] __initdata = {
 	/*
-- 
2.7.4

