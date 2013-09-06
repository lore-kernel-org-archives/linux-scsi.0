From: James Smart <james.smart@emulex.com>
Subject: [PATCH 18/18] lpfc 8.3.42: Update lpfc version to driver version
 8.3.42
Date: Fri, 6 Sep 2013 12:23:01 -0400
Message-ID: <1378484581.14051.37.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22380 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab3IFQXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:23:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 8.3.42


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2013-09-06 10:04:37.111059060 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.41"
+#define LPFC_DRIVER_VERSION "8.3.42"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */



