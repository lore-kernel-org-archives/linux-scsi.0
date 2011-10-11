From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/6] lpfc 8.3.27: Change driver version to 8.3.27
Date: Mon, 10 Oct 2011 21:34:27 -0400
Message-ID: <1318296869.5189.15.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:33721 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213Ab1JKBhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2011 21:37:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change driver version to 8.3.27

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2011-10-10 10:30:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2011-10-10 16:46:39.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.26"
+#define LPFC_DRIVER_VERSION "8.3.27"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"



