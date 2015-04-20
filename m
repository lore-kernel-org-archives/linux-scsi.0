From: James Smart <james.smart@emulex.com>
Subject: [PATCH 14/14] lpfc: Update driver version for upstream patch set
 10.6.0.1.
Date: Mon, 20 Apr 2015 09:56:38 -0400
Message-ID: <55350596.o7msQ4MujeU/k4Sh%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:29298 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbbDTN5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update driver version for upstream patch set 10.6.0.1.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c37bb9f..8b96d10 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "10.5.0.0."
+#define LPFC_DRIVER_VERSION "10.6.0.1."
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
1.7.11.7

