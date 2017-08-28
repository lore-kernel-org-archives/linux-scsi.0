From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH] scsi: ufs: Make use of UFS_BIT macro wherever possible
Date: Mon, 28 Aug 2017 17:49:43 +0530
Message-ID: <1503922783-14317-1-git-send-email-alim.akhtar@samsung.com>
References: <CGME20170828122625epcas2p33e3e912339c1e29051ad8e28251ea91b@epcas2p3.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

This entire file uses UFS_BIT macro for bits definition, expect for few
places. This patch convert those defines to use UFS_BIT macro to be aligned
with reset of the file.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshci.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index f60145d..588094a 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -186,9 +186,9 @@ enum {
 /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
 #define UIC_DATA_LINK_LAYER_ERROR		UFS_BIT(31)
 #define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK	0x7FFF
-#define UIC_DATA_LINK_LAYER_ERROR_PA_INIT	0x2000
-#define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED	0x0001
-#define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT 0x0002
+#define UIC_DATA_LINK_LAYER_ERROR_PA_INIT	UFS_BIT(13)
+#define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED	UFS_BIT(1)
+#define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT UFS_BIT(2)
 
 /* UECN - Host UIC Error Code Network Layer 40h */
 #define UIC_NETWORK_LAYER_ERROR			UFS_BIT(31)
-- 
2.7.4
