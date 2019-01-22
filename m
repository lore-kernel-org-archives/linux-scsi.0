From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: hpsa: clean up two indentation issues
Date: Tue, 22 Jan 2019 15:18:30 +0000
Message-ID: <20190122151830.7230-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two statements that are indented incorrectly. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hpsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ff67ef5d5347..5284444fdd10 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1327,7 +1327,7 @@ static int hpsa_scsi_add_entry(struct ctlr_info *h,
 		dev_warn(&h->pdev->dev, "physical device with no LUN=0,"
 			" suspect firmware bug or unsupported hardware "
 			"configuration.\n");
-			return -1;
+		return -1;
 	}
 
 lun_assigned:
@@ -4110,7 +4110,7 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 			"maximum logical LUNs (%d) exceeded.  "
 			"%d LUNs ignored.\n", HPSA_MAX_LUN,
 			*nlogicals - HPSA_MAX_LUN);
-			*nlogicals = HPSA_MAX_LUN;
+		*nlogicals = HPSA_MAX_LUN;
 	}
 	if (*nlogicals + *nphysicals > HPSA_MAX_PHYS_LUN) {
 		dev_warn(&h->pdev->dev,
-- 
2.19.1
