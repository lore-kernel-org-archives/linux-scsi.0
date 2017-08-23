From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 20/20] lpfc: lpfc version bump 11.4.0.3
Date: Wed, 23 Aug 2017 16:55:49 -0700
Message-ID: <20170823235549.2883-21-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34939 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751285AbdHWX4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:41 -0400
Received: by mail-wr0-f194.google.com with SMTP id n53so590505wrb.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:40 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Update driver version to 11.4.0.3

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c6a24c3e2d5e..6aa192b3e4bf 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.4.0.1"
+#define LPFC_DRIVER_VERSION "11.4.0.3"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.1
