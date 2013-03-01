From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/11] lpfc 8.3.38: Update lpfc version for 8.3.38 driver
 release
Date: Fri, 1 Mar 2013 16:38:29 -0500
Message-ID: <1362173909.8283.28.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:48035 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3CAVj7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:39:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version for 8.3.38 driver release


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2013-02-22 14:06:17.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2013-02-27 08:17:48.810048063 -0500
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.37"
+#define LPFC_DRIVER_VERSION "8.3.38"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */



