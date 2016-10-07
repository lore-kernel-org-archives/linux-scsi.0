From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi: update rdac devices at scsi_dh_rdac
Date: Fri,  7 Oct 2016 18:55:49 +0200
Message-ID: <20161007165549.6433-1-xose.vazquez@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36440 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935076AbcJGQzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2016 12:55:53 -0400
Received: by mail-wm0-f68.google.com with SMTP id 123so3801098wmb.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Oct 2016 09:55:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <Sean.Stewart@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

Remove IBM/1745 ghost array.
There is no references nowhere, also removed from multipath-tools
Confirmed by the original manufacturer(NetApp), and Google shows no results.

Replace too wide "TP9" regex with full names.
TP9100 is included, at it is not a RDAC array.
This reverts partially the commit 352047

Add IBM 3542 and 3552, they are FAStT200 and FAStT500

Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_dh.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index b8d3b97..a64b5ce 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -49,14 +49,18 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
 	{"IBM", "1724",			"rdac", },
 	{"IBM", "1726",			"rdac", },
 	{"IBM", "1742",			"rdac", },
-	{"IBM", "1745",			"rdac", },
 	{"IBM", "1746",			"rdac", },
 	{"IBM", "1813",			"rdac", },
 	{"IBM", "1814",			"rdac", },
 	{"IBM", "1815",			"rdac", },
 	{"IBM", "1818",			"rdac", },
 	{"IBM", "3526",			"rdac", },
-	{"SGI", "TP9",			"rdac", },
+	{"IBM", "3542",			"rdac", },
+	{"IBM", "3552",			"rdac", },
+	{"SGI", "TP9300",		"rdac", },
+	{"SGI", "TP9400",		"rdac", },
+	{"SGI", "TP9500",		"rdac", },
+	{"SGI", "TP9700",		"rdac", },
 	{"SGI", "IS",			"rdac", },
 	{"STK", "OPENstorage D280",	"rdac", },
 	{"STK", "FLEXLINE 380",		"rdac", },
-- 
2.10.1

