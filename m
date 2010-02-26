From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/7] lpfc 8.3.10: Update Driver version to 8.3.10
Date: Fri, 26 Feb 2010 14:16:25 -0500
Message-ID: <1267211805.3372.9.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4988 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965816Ab0BZTRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:17:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update Driver version to 8.3.10

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2010-02-25 16:35:06.000000000 -0500
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.9"
+#define LPFC_DRIVER_VERSION "8.3.10"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


