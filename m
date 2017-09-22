From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 19/19] lpfc: change version to 11.4.0.4
Date: Thu, 21 Sep 2017 23:17:41 -0700
Message-ID: <20170922061741.12347-20-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33069 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751896AbdIVGSO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:14 -0400
Received: by mail-pf0-f194.google.com with SMTP id h4so96403pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:14 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Change version to 11.4.0.4

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 6aa192b3e4bf..e0181371af09 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.4.0.3"
+#define LPFC_DRIVER_VERSION "11.4.0.4"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.13.1
