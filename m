From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/3] scsi: Remove VPD quirk for Seagate drives
Date: Tue, 20 Jan 2015 19:58:39 -0500
Message-ID: <1421801919-7137-3-git-send-email-martin.petersen@oracle.com>
References: <1421801919-7137-1-git-send-email-martin.petersen@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1421801919-7137-1-git-send-email-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now that we sanity check the optimal I/O size reported by the device we
no longer need to blacklist the VPD pages on certain Seagate drives.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_devinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 0118ddf163eb..ae86869ab6b6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -231,7 +231,6 @@ static struct {
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
 	{"SEAGATE", "ST34555N", "0930", BLIST_NOTQ},	/* Chokes on tagged INQUIRY */
 	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
-	{"SEAGATE", "ST900MM0006", NULL, BLIST_SKIP_VPD_PAGES},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
-- 
1.9.3
