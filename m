From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 16/16] lpfc: Update lpfc version to 11.2.0.7
Date: Sun, 12 Feb 2017 13:52:40 -0800
Message-ID: <58a0d928.Zhz1nZh7kjbELlcG%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36149 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdBLVwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2017 16:52:43 -0500
Received: by mail-oi0-f67.google.com with SMTP id u143so5855806oif.3
        for <linux-scsi@vger.kernel.org>; Sun, 12 Feb 2017 13:52:43 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


Update lpfc version to 11.2.0.7

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 0d93535..86c6c9b 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.4"
+#define LPFC_DRIVER_VERSION "11.2.0.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.5.0
