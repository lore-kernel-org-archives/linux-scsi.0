From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 9/9] lpfc: update driver version to 11.4.0.6
Date: Fri,  8 Dec 2017 17:18:11 -0800
Message-ID: <20171209011811.23421-10-jsmart2021@gmail.com>
References: <20171209011811.23421-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:44117 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753738AbdLIBSd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2017 20:18:33 -0500
Received: by mail-qk0-f193.google.com with SMTP id h19so1028222qkj.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2017 17:18:32 -0800 (PST)
In-Reply-To: <20171209011811.23421-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Update the driver version to 11.4.0.6

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index cc2f5cec98c5..c232bf0e8998 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.4.0.5"
+#define LPFC_DRIVER_VERSION "11.4.0.6"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.1
