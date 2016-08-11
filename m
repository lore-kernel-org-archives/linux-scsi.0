From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 14/14] lpfc: lpfc version change to 11.2.0.2
Date: Thu, 11 Aug 2016 11:36:01 -0700
Message-ID: <57acc591.0V98JsEa57Kt7jan%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35225 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbcHKSgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:36:04 -0400
Received: by mail-qk0-f182.google.com with SMTP id v123so4148437qkh.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:36:04 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id g3sm935571qkf.35.2016.08.11.11.36.02
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:36:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


lpfc version change to 11.2.0.2

Note: expects to be on top of prior lpfc 11.2.0.0. rev and not on
top of lpfc rev 11.2.0.1 which has fc-nvme mods as well. The patches in
this set should apply to 11.2.0.1, excepting this version change.
For now, this patch based on contents in scsi-misc branch of scsi git tree.

11.2.0.1 has not yet been pulled into a linux-block branch (where nvme
fabrics support is).

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c9bf20e..dc49fcb 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.0."
+#define LPFC_DRIVER_VERSION "11.2.0.2."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.5.0

