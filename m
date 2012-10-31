From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/7] lpfc 8.3.36: Update lpfc version for 8.3.36 driver
 release
Date: Wed, 31 Oct 2012 14:45:29 -0400
Message-ID: <1351709129.957.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:15783 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2JaSqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2012 14:46:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version for 8.3.36 driver release


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2012-10-23 09:51:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2012-10-29 11:18:43.624033102 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.35"
+#define LPFC_DRIVER_VERSION "8.3.36"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */



