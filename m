From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 9/9] lpfc: Update driver version to 11.1.0.0
Date: Thu, 31 Mar 2016 14:12:35 -0700
Message-ID: <56fd92c3.ffOf/tH69D+f7oCz%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35122 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbcCaVMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:39 -0400
Received: by mail-pa0-f48.google.com with SMTP id td3so73870167pab.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:39 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id x18sm15506461pfi.42.2016.03.31.14.12.37
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update driver version to 11.1.0.0

Update driver version 11.1.0.0

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 6b57e0c..fa0d531 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.0.0.10."
+#define LPFC_DRIVER_VERSION "11.1.0.0."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.5.0

