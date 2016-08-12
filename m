From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi: blacklist all RDAC devices for BLIST_NO_ULD_ATTACH
Date: Sat, 13 Aug 2016 00:56:03 +0200
Message-ID: <1471042563-5084-1-git-send-email-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34104 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbcHLW4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2016 18:56:07 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so44444wma.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2016 15:56:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <Sean.Stewart@netapp.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

"Universal Xport" LUN is used for in-band storage array management.

Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index eaccd65..2464569 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -246,6 +246,10 @@ static struct {
 	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"STK", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"NETAPP", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
-- 
2.7.4

