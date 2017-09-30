From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 3/3] scsi: ufs: Remove unused UFS_BIT() macro
Date: Sat, 30 Sep 2017 11:52:06 +0530
Message-ID: <1506752526-27014-3-git-send-email-alim.akhtar@samsung.com>
References: <1506752526-27014-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20170930062958epcas2p281a91f030037be81ef81c657ec6f81b2@epcas2p2.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1506752526-27014-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, subhashj@codeaurora.org, Bart.VanAssche@wdc.com
List-Id: linux-scsi@vger.kernel.org

Since we have coverted all the user of UFS_BIT() macro
with the actual bit position, let remove unused UFS_BIT()macro.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshci.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 5a60a8f..c51fa6d 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -119,7 +119,6 @@ enum {
 #define MANUFACTURE_ID_MASK	UFS_MASK(0xFFFF, 0)
 #define PRODUCT_ID_MASK		UFS_MASK(0xFFFF, 16)
 
-#define UFS_BIT(x)     (1L << (x))
 /*
  * IS - Interrupt Status - 20h
  */
-- 
2.7.4
