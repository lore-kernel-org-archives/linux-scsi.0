From: Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH] ufs: Add missing UFS_MASK macro definition
Date: Thu, 24 Nov 2016 12:58:51 +0800
Message-ID: <1479963531-6458-1-git-send-email-zhangfei.gao@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:36233 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755157AbcKXE7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 23:59:46 -0500
Received: by mail-pg0-f46.google.com with SMTP id f188so13937749pgc.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2016 20:59:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Zhangfei Gao <zhangfei.gao@linaro.org>

From: Santosh Y <santoshsy@gmail.com>

Reported-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Y <santoshsy@gmail.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---

Find the original patch from
http://www.spinics.net/lists/linux-scsi/msg58634.html

 drivers/scsi/ufs/ufshci.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 9599741..bbd8df9 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -83,6 +83,8 @@ enum {
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
 };
 
+#define UFS_MASK(mask, offset)		((mask) << (offset))
+
 /* UFS Version 08h */
 #define MINOR_VERSION_NUM_MASK		UFS_MASK(0xFFFF, 0)
 #define MAJOR_VERSION_NUM_MASK		UFS_MASK(0xFFFF, 16)
-- 
2.7.4

