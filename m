From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] scsi: Remove VPD quirk for Seagate drives
Date: Tue, 23 Jun 2015 12:22:21 -0400
Message-ID: <1435076541-27253-2-git-send-email-martin.petersen@oracle.com>
References: <1435076541-27253-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44593 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbbFWQWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 12:22:33 -0400
In-Reply-To: <1435076541-27253-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org

Now that we sanity check the optimal I/O size reported by the device we
no longer need to blacklist the VPD pages on certain Seagate drives.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_devinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 9f77d23239a2..f04f1b672962 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -232,7 +232,6 @@ static struct {
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
 	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
 	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
-	{"SEAGATE", "ST900MM0006", NULL, BLIST_SKIP_VPD_PAGES},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
-- 
2.4.3

