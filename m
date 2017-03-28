From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/6] scsi: ufs: use existing macro CONTROLLER_ENABLE to test register bit
Date: Tue, 28 Mar 2017 16:49:25 +0300
Message-ID: <20170328134929.25599-2-tkusumi@tuxera.com>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35284 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbdC1NuA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 09:50:00 -0400
Received: by mail-lf0-f65.google.com with SMTP id v2so10582043lfi.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2017 06:49:48 -0700 (PDT)
In-Reply-To: <20170328134929.25599-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

(Note this commit directly goes on top of the previous one)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b006f1e..dd46259 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -836,7 +836,8 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
  */
 static inline bool ufshcd_is_hba_active(struct ufs_hba *hba)
 {
-	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? false : true;
+	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & CONTROLLER_ENABLE)
+		? false : true;
 }
 
 static const char *ufschd_uic_link_state_to_string(
-- 
2.9.3
