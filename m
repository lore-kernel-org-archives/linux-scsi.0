From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 12/13] lpfc: update driver version to 12.0.0.0
Date: Tue,  6 Feb 2018 18:28:50 -0800
Message-ID: <20180207022851.11800-13-jsmart2021@gmail.com>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:46080 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbeBGC3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 21:29:09 -0500
Received: by mail-ot0-f193.google.com with SMTP id f56so3760355otj.13
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 18:29:09 -0800 (PST)
In-Reply-To: <20180207022851.11800-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Update the driver version to 12.0.0.0

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 4adbf07880a2..b1ae62a44aae 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.4.0.7"
+#define LPFC_DRIVER_VERSION "12.0.0.0"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.1
