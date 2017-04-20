From: jsmart2021@gmail.com
Subject: [PATCH-v1 22/22] lpfc revison 11.2.0.12
Date: Wed, 19 Apr 2017 21:46:41 -0700
Message-ID: <20170420044641.10657-23-jsmart2021@gmail.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35448 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941199AbdDTEri (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:47:38 -0400
Received: by mail-oi0-f67.google.com with SMTP id g11so5674601oib.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:47:33 -0700 (PDT)
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Update lpfc version to reflect this set of changes.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index d4e95e2..1c26dc6 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.10"
+#define LPFC_DRIVER_VERSION "11.2.0.12"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.1.0
