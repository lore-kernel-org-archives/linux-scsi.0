From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/8] lpfc 8.3.25: Change driver version to 8.3.25
Date: Fri, 22 Jul 2011 18:38:16 -0400
Message-ID: <1311374310.10545.35.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:6005 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277Ab1GVWim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2011 18:38:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change driver version to 8.3.25

Note: This patch Subsumes the version patch that was in 8.3.24
   that James Bottomley has yet to apply.
   http://marc.info/?l=linux-scsi&m=130625191125321&w=2


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2011-05-20 19:54:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2011-07-22 17:37:14.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.23"
+#define LPFC_DRIVER_VERSION "8.3.25"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


