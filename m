From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 17/17 v2] lpfc: lpfc version changed to 11.2.0.2
Date: Wed, 12 Oct 2016 13:14:20 -0700
Message-ID: <57fe999c.tNDMwGNK2T9Dzedz%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:59068 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932566AbcJLUOm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:42 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id 16D3012099C
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


lpfc version changed to 11.2.0.2

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c9bf20e..50bfc43 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "11.2.0.0."
+#define LPFC_DRIVER_VERSION "11.2.0.2"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.5.0


