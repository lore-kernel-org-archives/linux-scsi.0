From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/7] lpfc 8.3.12: Update Driver version to 8.3.12
Date: Tue, 6 Apr 2010 15:07:03 -0400
Message-ID: <1270580843.28785.5.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16080 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757084Ab0DFTHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 15:07:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update Driver version to 8.3.12

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2010-04-06 12:59:19.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.11"
+#define LPFC_DRIVER_VERSION "8.3.12"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


