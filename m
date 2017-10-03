From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 4/4] scsi: ufs: Remove unused UFS_BIT() macro
Date: Tue, 03 Oct 2017 20:51:25 +0530
Message-ID: <1507044085-16905-4-git-send-email-alim.akhtar@samsung.com>
References: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20171003152912epcas1p442acf97496d1473907d6d73b7c51aa82@epcas1p4.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, subhashj@codeaurora.org, Bart.VanAssche@wdc.com
List-Id: linux-scsi@vger.kernel.org

Since we have converted all the user of UFS_BIT() macro
with the actual bit position, let remove unused UFS_BIT()macro.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshci.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index dec0420..277752b 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -119,8 +119,6 @@ enum {
 #define MANUFACTURE_ID_MASK	UFS_MASK(0xFFFF, 0)
 #define PRODUCT_ID_MASK		UFS_MASK(0xFFFF, 16)
 
-#define UFS_BIT(x)	(1L << (x))
-
 /*
  * IS - Interrupt Status - 20h
  */
-- 
2.7.4
