From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bfa: use ARRAY_SIZE for array sizing calculation on array __pciids
Date: Sun,  7 Jan 2018 23:15:10 +0000
Message-ID: <20180107231510.7755-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Use the ARRAY_SIZE macro on array __pciids to determine size of the array.
Improvement suggested by coccinelle.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bfa/bfa_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 3e1caec82554..10a63be92544 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1957,7 +1957,7 @@ bfa_get_pciids(struct bfa_pciid_s **pciids, int *npciids)
 		{BFA_PCI_VENDOR_ID_BROCADE, BFA_PCI_DEVICE_ID_CT_FC},
 	};
 
-	*npciids = sizeof(__pciids) / sizeof(__pciids[0]);
+	*npciids = ARRAY_SIZE(__pciids);
 	*pciids = __pciids;
 }
 
-- 
2.15.1
