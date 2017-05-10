From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 15/15] lpfc: update version to 11.2.0.14
Date: Wed, 10 May 2017 12:07:13 -0700
Message-ID: <20170510190713.30171-16-jsmart2021@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34282 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754073AbdEJTHk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2017 15:07:40 -0400
Received: by mail-qk0-f194.google.com with SMTP id u75so726790qka.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 May 2017 12:07:40 -0700 (PDT)
In-Reply-To: <20170510190713.30171-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Change driver version to 11.2.0.14

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 1c26dc67151b..c2653244221c 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.12"
+#define LPFC_DRIVER_VERSION "11.2.0.14"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.11.0
