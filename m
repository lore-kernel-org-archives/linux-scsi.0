From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/30] hpsa: remove unwanted debug code
Date: Thu, 04 Feb 2010 08:42:14 -0600
Message-ID: <20100204144214.10406.23996.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: remove unwanted debug code

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bd081fe..4594200 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1580,9 +1580,6 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	}
 	memcpy(nphysicals, &physdev->LUNListLength[0], sizeof(*nphysicals));
 	*nphysicals = be32_to_cpu(*nphysicals) / 8;
-#ifdef DEBUG
-	dev_info(&h->pdev->dev, "number of physical luns is %d\n", *nphysicals);
-#endif
 	if (*nphysicals > HPSA_MAX_PHYS_LUN) {
 		dev_warn(&h->pdev->dev, "maximum physical LUNs (%d) exceeded."
 			"  %d LUNs ignored.\n", HPSA_MAX_PHYS_LUN,
@@ -1595,9 +1592,6 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	}
 	memcpy(nlogicals, &logdev->LUNListLength[0], sizeof(*nlogicals));
 	*nlogicals = be32_to_cpu(*nlogicals) / 8;
-#ifdef DEBUG
-	dev_info(&h->pdev->dev, "number of logical luns is %d\n", *nlogicals);
-#endif
 	/* Reject Logicals in excess of our max capability. */
 	if (*nlogicals > HPSA_MAX_LUN) {
 		dev_warn(&h->pdev->dev,
