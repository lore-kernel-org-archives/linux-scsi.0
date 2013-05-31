From: James Smart <james.smart@emulex.com>
Subject: [PATCH 17/17] lpfc 8.3.40: Update lpfc version to driver version
 8.3.40
Date: Fri, 31 May 2013 17:05:53 -0400
Message-ID: <1370034353.17258.39.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5813 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3EaVM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:12:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 8.3.40


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2013-05-31 10:58:29.636057897 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.39"
+#define LPFC_DRIVER_VERSION "8.3.40"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */



