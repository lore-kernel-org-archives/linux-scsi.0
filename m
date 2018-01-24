From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 18/19] lpfc: update driver version to 11.4.0.7
Date: Wed, 24 Jan 2018 14:45:47 -0800
Message-ID: <20180124224548.9530-19-jsmart2021@gmail.com>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:46474 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933059AbeAXWqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:46:23 -0500
Received: by mail-qt0-f196.google.com with SMTP id o35so14611657qtj.13
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:46:23 -0800 (PST)
In-Reply-To: <20180124224548.9530-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Update the driver version to 11.4.0.7

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c232bf0e8998..6f4092cb903e 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.4.0.6"
+#define LPFC_DRIVER_VERSION "11.4.0.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.1
