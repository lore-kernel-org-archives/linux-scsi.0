From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi: scsi_devinfo: replace "Dell PV 650F" with "EMC CLARiiON"
Date: Thu, 23 Nov 2017 20:16:14 +0100
Message-ID: <20171123191614.3231-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40577 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752948AbdKWTQT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Nov 2017 14:16:19 -0500
Received: by mail-wm0-f67.google.com with SMTP id b189so18495586wmd.5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Nov 2017 11:16:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>

The Dell PV650F is a re-branded CLARiiON FC5700.
And DGC/RAID,DISK identifies all CLARiiON family.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index fe5a9ea27b5e..97f0e24341c9 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -159,8 +159,8 @@ static struct {
 	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},	/* Dell PV 530F */
 	{"DELL", "PV530F", NULL, BLIST_SPARSELUN},
 	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},
-	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
-	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
+	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, storage on LUN 0 */
+	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, no storage on LUN 0 */
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_REPORTLUN2},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
-- 
2.14.3
