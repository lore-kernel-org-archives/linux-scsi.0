From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/4] lpfc 8.3.26: Change driver version to 8.3.26
Date: Sun, 21 Aug 2011 21:49:49 -0400
Message-ID: <1313977790.21906.7.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:6407 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756367Ab1HVBuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2011 21:50:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change driver version to 8.3.26


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2011-08-19 23:25:08.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.25"
+#define LPFC_DRIVER_VERSION "8.3.26"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"




