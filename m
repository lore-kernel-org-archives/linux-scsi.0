From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 03/11] scsi: ufs: update device descriptor maximum size
Date: Wed, 23 Nov 2016 16:31:30 -0800
Message-ID: <1479947491-7016-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

According to JESD220B - UFS v2.0, the maximum size of device descriptor
has changed from 0x1F to 0x40. This patch updates the maximum size of
this descriptor.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 7a6ccb6..8e6709a 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -163,7 +163,7 @@ enum desc_header_offset {
 };
 
 enum ufs_desc_max_size {
-	QUERY_DESC_DEVICE_MAX_SIZE		= 0x1F,
+	QUERY_DESC_DEVICE_MAX_SIZE		= 0x40,
 	QUERY_DESC_CONFIGURAION_MAX_SIZE	= 0x90,
 	QUERY_DESC_UNIT_MAX_SIZE		= 0x23,
 	QUERY_DESC_INTERCONNECT_MAX_SIZE	= 0x06,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
