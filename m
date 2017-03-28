From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/6] scsi: ufs: remove deprecated enum for hw interrupt
Date: Tue, 28 Mar 2017 16:49:28 +0300
Message-ID: <20170328134929.25599-5-tkusumi@tuxera.com>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36505 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdC1Nug (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 09:50:36 -0400
Received: by mail-lf0-f68.google.com with SMTP id n78so10570910lfi.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2017 06:50:15 -0700 (PDT)
In-Reply-To: <20170328134929.25599-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

These flags are no longer needed after 2fbd009b in 2013.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 089b76f..109a762 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -143,13 +143,6 @@ enum {
 	UFSHCD_UIC_DME_ERROR = (1 << 5), /* DME error */
 };
 
-/* Interrupt configuration options */
-enum {
-	UFSHCD_INT_DISABLE,
-	UFSHCD_INT_ENABLE,
-	UFSHCD_INT_CLEAR,
-};
-
 #define ufshcd_set_eh_in_progress(h) \
 	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
 #define ufshcd_eh_in_progress(h) \
-- 
2.9.3
