From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 17/17] lpfc: Update lpfc version to 11.2.0.7
Date: Tue, 17 Jan 2017 17:21:00 -0800
Message-ID: <587ec2fc.VRwkzlaMrjIvUNsO%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34865 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdARB3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 20:29:14 -0500
Received: by mail-wm0-f65.google.com with SMTP id d140so298249wmd.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 17:29:14 -0800 (PST)
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
index 4e46ce4..9dfdab1 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.4"
+#define LPFC_DRIVER_VERSION "11.2.0.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFCMGMT_NAME			"lpfcmgmt"
 
-- 
2.5.0

