From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi_dh: fix format of struct members
Date: Sat, 16 Dec 2017 17:19:07 +0100
Message-ID: <20171216161907.6204-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:46141 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbdLPQTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Dec 2017 11:19:14 -0500
Received: by mail-wm0-f68.google.com with SMTP id r78so22528839wme.5
        for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2017 08:19:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>

Remove useless trailing comma and space.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_dh.c | 66 +++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index b88b5dbbc444..bbbe279970e4 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -36,43 +36,43 @@ struct scsi_dh_blist {
 };
 
 static const struct scsi_dh_blist scsi_dh_blist[] = {
-	{"DGC", "RAID",			"emc" },
-	{"DGC", "DISK",			"emc" },
-	{"DGC", "VRAID",		"emc" },
+	{"DGC", "RAID",			"emc"},
+	{"DGC", "DISK",			"emc"},
+	{"DGC", "VRAID",		"emc"},
 
-	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw" },
-	{"COMPAQ", "HSV110",		"hp_sw" },
+	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw"},
+	{"COMPAQ", "HSV110",		"hp_sw"},
 	{"HP", "HSV100",		"hp_sw"},
 	{"DEC", "HSG80",		"hp_sw"},
 
-	{"IBM", "1722",			"rdac", },
-	{"IBM", "1724",			"rdac", },
-	{"IBM", "1726",			"rdac", },
-	{"IBM", "1742",			"rdac", },
-	{"IBM", "1745",			"rdac", },
-	{"IBM", "1746",			"rdac", },
-	{"IBM", "1813",			"rdac", },
-	{"IBM", "1814",			"rdac", },
-	{"IBM", "1815",			"rdac", },
-	{"IBM", "1818",			"rdac", },
-	{"IBM", "3526",			"rdac", },
-	{"IBM", "3542",			"rdac", },
-	{"IBM", "3552",			"rdac", },
-	{"SGI", "TP9",			"rdac", },
-	{"SGI", "IS",			"rdac", },
-	{"STK", "OPENstorage",		"rdac", },
-	{"STK", "FLEXLINE 380",		"rdac", },
-	{"STK", "BladeCtlr",		"rdac", },
-	{"SUN", "CSM",			"rdac", },
-	{"SUN", "LCSM100",		"rdac", },
-	{"SUN", "STK6580_6780",		"rdac", },
-	{"SUN", "SUN_6180",		"rdac", },
-	{"SUN", "ArrayStorage",		"rdac", },
-	{"DELL", "MD3",			"rdac", },
-	{"NETAPP", "INF-01-00",		"rdac", },
-	{"LSI", "INF-01-00",		"rdac", },
-	{"ENGENIO", "INF-01-00",	"rdac", },
-	{NULL, NULL,			NULL },
+	{"IBM", "1722",			"rdac"},
+	{"IBM", "1724",			"rdac"},
+	{"IBM", "1726",			"rdac"},
+	{"IBM", "1742",			"rdac"},
+	{"IBM", "1745",			"rdac"},
+	{"IBM", "1746",			"rdac"},
+	{"IBM", "1813",			"rdac"},
+	{"IBM", "1814",			"rdac"},
+	{"IBM", "1815",			"rdac"},
+	{"IBM", "1818",			"rdac"},
+	{"IBM", "3526",			"rdac"},
+	{"IBM", "3542",			"rdac"},
+	{"IBM", "3552",			"rdac"},
+	{"SGI", "TP9",			"rdac"},
+	{"SGI", "IS",			"rdac"},
+	{"STK", "OPENstorage",		"rdac"},
+	{"STK", "FLEXLINE 380",		"rdac"},
+	{"STK", "BladeCtlr",		"rdac"},
+	{"SUN", "CSM",			"rdac"},
+	{"SUN", "LCSM100",		"rdac"},
+	{"SUN", "STK6580_6780",		"rdac"},
+	{"SUN", "SUN_6180",		"rdac"},
+	{"SUN", "ArrayStorage",		"rdac"},
+	{"DELL", "MD3",			"rdac"},
+	{"NETAPP", "INF-01-00",		"rdac"},
+	{"LSI", "INF-01-00",		"rdac"},
+	{"ENGENIO", "INF-01-00",	"rdac"},
+	{NULL, NULL,			NULL},
 };
 
 static const char *
-- 
2.14.3
