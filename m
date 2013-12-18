From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/7 V2] lpfc 8.3.44: Update lpfc version to driver version
 8.3.44
Date: Tue, 17 Dec 2013 20:30:18 -0500
Message-ID: <1387330218.1011.15.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41181 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3LRBaW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 20:30:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 8.3.44


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2013-12-02 11:52:19.659242225 -0500
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.43"
+#define LPFC_DRIVER_VERSION "8.3.44"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */


