From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi: replace wrong device handler name for CLARiiON arrays
Date: Fri,  7 Oct 2016 18:19:57 +0200
Message-ID: <20161007161957.6042-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36500 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933121AbcJGQUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2016 12:20:03 -0400
Received: by mail-wm0-f65.google.com with SMTP id 123so3666414wmb.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Oct 2016 09:20:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

At drivers/scsi/device_handler/scsi_dh_emc.c it was defined as:
#define CLARIION_NAME                   "emc"

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_dh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 54d446c..b8d3b97 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -36,9 +36,9 @@ struct scsi_dh_blist {
 };
 
 static const struct scsi_dh_blist scsi_dh_blist[] = {
-	{"DGC", "RAID",			"clariion" },
-	{"DGC", "DISK",			"clariion" },
-	{"DGC", "VRAID",		"clariion" },
+	{"DGC", "RAID",			"emc" },
+	{"DGC", "DISK",			"emc" },
+	{"DGC", "VRAID",		"emc" },
 
 	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw" },
 	{"COMPAQ", "HSV110",		"hp_sw" },
-- 
2.10.1

