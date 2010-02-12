From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/6] lpfc 8.3.9: Update Driver version to 8.3.9
Date: Fri, 12 Feb 2010 14:43:34 -0500
Message-ID: <1266003834.2939.19.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49998 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756634Ab0BLToL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 14:44:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2010-02-11 17:26:55.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2010-02-12 10:53:58.000000000 -0500
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.8"
+#define LPFC_DRIVER_VERSION "8.3.9"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


