From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 17/17] lpfc: update driver version to 11.4.0.5
Date: Mon, 20 Nov 2017 16:00:44 -0800
Message-ID: <20171121000044.27702-18-jsmart2021@gmail.com>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43057 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbdKUABN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 19:01:13 -0500
Received: by mail-qt0-f194.google.com with SMTP id w10so5030499qtb.10
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2017 16:01:13 -0800 (PST)
In-Reply-To: <20171121000044.27702-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Update the driver version to 11.4.0.5

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index e0181371af09..cc2f5cec98c5 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.4.0.4"
+#define LPFC_DRIVER_VERSION "11.4.0.5"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.1
