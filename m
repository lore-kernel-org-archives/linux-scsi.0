From: Kyuho Choi <chlrbgh0@gmail.com>
Subject: [PATCH] scsi: ufs: enable no vccq quirk for skhynix device
Date: Mon, 26 Sep 2016 23:58:25 +0900
Message-ID: <1474901905-21551-1-git-send-email-kyuho.choi@sk.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36582 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034251AbcIZO6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 10:58:31 -0400
Received: by mail-pf0-f194.google.com with SMTP id n24so9244541pfb.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 07:58:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Kyuho Choi <kyuho.choi@sk.com>

This patch enable no vccq quirk for SKHynix devices.
SKHynix ufs device don't need vccq vrail for device operation.

Signed-off-by: Kyuho Choi <kyuho.choi@sk.com>
---
 drivers/scsi/ufs/ufs_quirks.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index ee4ab85..22f881e 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -25,6 +25,7 @@
 
 #define UFS_VENDOR_TOSHIBA     0x198
 #define UFS_VENDOR_SAMSUNG     0x1CE
+#define UFS_VENDOR_SKHYNIX     0x1AD
 
 /**
  * ufs_device_info - ufs device details
@@ -145,6 +146,7 @@ static struct ufs_dev_fix ufs_fixups[] = {
 		UFS_DEVICE_QUIRK_PA_TACTIVATE),
 	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
 		UFS_DEVICE_QUIRK_PA_TACTIVATE),
+	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
 
 	END_FIX
 };
-- 
2.7.4

