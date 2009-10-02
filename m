From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 6/6] lpfc 8.3.5: Update the lpfc driver version to 8.3.5
Date: Fri, 2 Oct 2009 15:17:08 -0400
Message-ID: <1254511028.32739.27.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64022 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbZJBT7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 15:59:10 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n92JxEh7026982
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 12:59:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Update lpfc driver version to 8.3.5


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2009-08-03 11:05:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2009-10-01 17:22:28.000000000 -0400
@@ -18,8 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.3.4"
-
+#define LPFC_DRIVER_VERSION "8.3.5"
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"
 #define LPFC_FP_DRIVER_HANDLER_NAME	"lpfc:fp"


