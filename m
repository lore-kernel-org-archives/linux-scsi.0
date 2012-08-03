From: James Smart <james.smart@emulex.com>
Subject: [PATCH 21/21] lpfc 8.3.33: Update lpfc version for 8.3.33 driver
 release
Date: Fri, 3 Aug 2012 12:37:17 -0400
Message-ID: <1344011837.6110.46.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40356 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2HCQhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:37:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version for 8.3.33 driver release


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2012-07-22 14:29:51.452268157 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2012-07-22 14:36:50.174253613 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.32"
+#define LPFC_DRIVER_VERSION "8.3.33"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */



