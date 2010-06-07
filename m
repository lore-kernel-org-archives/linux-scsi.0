From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/6][REPOST] lpfc 8.3.13: Update Driver Version to 8.3.13
Date: Mon, 7 Jun 2010 15:24:54 -0400
Message-ID: <1275938732.9049.18.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38397 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753396Ab0FGTZw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2010 15:25:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update Driver Version to 8.3.13

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2010-05-05 08:52:38.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2010-05-12 09:05:36.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.12"
+#define LPFC_DRIVER_VERSION "8.3.13"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


