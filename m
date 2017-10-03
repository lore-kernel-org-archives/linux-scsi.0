From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 3/4] scsi: ufs: Remove unused #defines
Date: Tue, 03 Oct 2017 20:51:24 +0530
Message-ID: <1507044085-16905-3-git-send-email-alim.akhtar@samsung.com>
References: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20171003152911epcas2p31ec5c2819836a1999ce41555f72aeca6@epcas2p3.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, subhashj@codeaurora.org, Bart.VanAssche@wdc.com
List-Id: linux-scsi@vger.kernel.org

HOST_ERROR_INDICATOR and DEVICE_ERROR_INDICATOR are not used
anywhere. Also as per JESD223C specification, bit[7:4] are reserved.
Lets remove these #defines.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshci.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 0d78ed3..dec0420 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -159,8 +159,6 @@ enum {
 #define UTP_TRANSFER_REQ_LIST_READY		0x2
 #define UTP_TASK_REQ_LIST_READY			0x4
 #define UIC_COMMAND_READY			0x8
-#define HOST_ERROR_INDICATOR			UFS_BIT(4)
-#define DEVICE_ERROR_INDICATOR			UFS_BIT(5)
 #define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK	UFS_MASK(0x7, 8)
 
 #define UFSHCD_STATUS_READY	(UTP_TRANSFER_REQ_LIST_READY |\
-- 
2.7.4
