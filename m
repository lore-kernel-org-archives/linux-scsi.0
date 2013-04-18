From: James Smart <james.smart@emulex.com>
Subject: [PATCH 22/22] lpfc 8.3.39: Update lpfc version for 8.3.39 driver
 release
Date: Wed, 17 Apr 2013 20:20:10 -0400
Message-ID: <1366244410.1513.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24350 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3DRAUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:20:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version for 8.3.39 driver release


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2013-04-15 18:26:58.178041602 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.38"
+#define LPFC_DRIVER_VERSION "8.3.39"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */



