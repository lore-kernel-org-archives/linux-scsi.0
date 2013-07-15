From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/13] lpfc 8.3.41: Update lpfc version to driver version
 8.3.41
Date: Mon, 15 Jul 2013 18:35:55 -0400
Message-ID: <1373927755.15647.30.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4573 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab3GOWf6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:35:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 8.3.41 


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2013-07-15 07:15:34.546056215 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.40"
+#define LPFC_DRIVER_VERSION "8.3.41"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */




