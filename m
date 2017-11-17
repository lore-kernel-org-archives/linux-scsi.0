From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi_devinfo: apply to HP XP the same flags as Hitachi VSP
Date: Fri, 17 Nov 2017 21:31:36 +0100
Message-ID: <20171117203136.8833-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38204 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934775AbdKQUbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 15:31:40 -0500
Received: by mail-wm0-f68.google.com with SMTP id 128so217977wmo.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 12:31:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Hannes Reinecke <hare@suse.de>, Takahiro Yasui <takahiro.yasui@hds.com>, Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>

56f3d383f modified some Hitachi entries:

   HITACHI is always supporting VPD pages, even though it's claiming to
   support SCSI Revision 3 only.
~~~

The same should have been done also for HP-rebranded.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Takahiro Yasui <takahiro.yasui@hds.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 320d0a81358d..3ab4d337bf55 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -182,7 +182,7 @@ static struct {
 	{"HITACHI", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
-	{"HP", "OPEN-", "*", BLIST_REPORTLUN2}, /* HP XP Arrays */
+	{"HP", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
 	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
-- 
2.14.3
