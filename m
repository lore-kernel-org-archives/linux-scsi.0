From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/6] lpfc 8.3.17: Update lpfc driver version to 8.3.17
Date: Wed, 29 Sep 2010 11:19:22 -0400
Message-ID: <1285773562.25110.14.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16109 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372Ab0I2PTo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 11:19:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update lpfc driver version to 8.3.17

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2010-08-09 09:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2010-09-29 10:20:58.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.16"
+#define LPFC_DRIVER_VERSION "8.3.17"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


