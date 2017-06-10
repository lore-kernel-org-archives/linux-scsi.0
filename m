From: butao <butao@hisilicon.com>
Subject: [PATCH 1/3] scsi:ufs:add AHIT for hi3660 ufs
Date: Sat, 10 Jun 2017 09:20:45 +0800
Message-ID: <20170610012045.33325-1-butao@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:7396 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFJBVC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2017 21:21:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guodong.xu@linaro.org, gengjianfeng@hisilicon.com, kongfei@hisilicon.com, suzhuangluan@hisilicon.com, steven.yujianfeng@hisilicon.com, zangleigang@hisilicon.com, butao@hisilicon.com

add Auto-Hibernate Idle Timer value for hi3660 ufs

Signed-off-by: Bu Tao <butao@hisilicon.com>
Signed-off-by: Geng Jianfeng <gengjianfeng@hisilicon.com>
Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
Signed-off-by: Yu Jianfeng <steven.yujianfeng@hisilicon.com>
---
 drivers/scsi/ufs/ufshci.h | 3 +++
 1 file changed, 3 insertions(+)
 mode change 100644 => 100755 drivers/scsi/ufs/ufshci.h

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
old mode 100644
new mode 100755
index f60145d4a66e..5ab9dfe4280e
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -151,6 +151,9 @@ enum {
 				CONTROLLER_FATAL_ERROR |\
 				SYSTEM_BUS_FATAL_ERROR)
 
+/* AHIT - Auto-Hibernate Idle Timer */
+#define UFS_AHIT_AH8ITV_MASK			0x3FF
+
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				UFS_BIT(0)
 #define UTP_TRANSFER_REQ_LIST_READY		UFS_BIT(1)
-- 
2.11.GIT
