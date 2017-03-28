From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/6] scsi: ufs: non functional macro fix
Date: Tue, 28 Mar 2017 16:49:26 +0300
Message-ID: <20170328134929.25599-3-tkusumi@tuxera.com>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36498 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753001AbdC1Nu3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 09:50:29 -0400
Received: by mail-lf0-f65.google.com with SMTP id n78so10570838lfi.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2017 06:50:09 -0700 (PDT)
In-Reply-To: <20170328134929.25599-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Not having () isn't likely to do any harm in this case, but all the
other macros below do have it. Also add "are" in a comment.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dd46259..089b76f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -151,11 +151,11 @@ enum {
 };
 
 #define ufshcd_set_eh_in_progress(h) \
-	(h->eh_flags |= UFSHCD_EH_IN_PROGRESS)
+	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
 #define ufshcd_eh_in_progress(h) \
-	(h->eh_flags & UFSHCD_EH_IN_PROGRESS)
+	((h)->eh_flags & UFSHCD_EH_IN_PROGRESS)
 #define ufshcd_clear_eh_in_progress(h) \
-	(h->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
+	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
 
 #define ufshcd_set_ufs_dev_active(h) \
 	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
@@ -1491,7 +1491,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 			break;
 		}
 		/*
-		 * If we here, it means gating work is either done or
+		 * If we are here, it means gating work is either done or
 		 * currently running. Hence, fall through to cancel gating
 		 * work and to enable clocks.
 		 */
-- 
2.9.3
