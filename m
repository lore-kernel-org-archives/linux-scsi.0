From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 20/20] lpfc: lpfc version bump 11.4.0.3
Date: Fri,  4 Aug 2017 17:47:31 -0700
Message-ID: <20170805004731.1335-21-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34967 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbdHEAsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:16 -0400
Received: by mail-pg0-f65.google.com with SMTP id l64so3110601pge.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:16 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Update driver version to 11.4.0.3

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
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
