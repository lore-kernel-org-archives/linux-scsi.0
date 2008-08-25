From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 15/15] lpfc 8.2.8 : update driver version to 8.2.8
Date: Sun, 24 Aug 2008 21:50:45 -0400
Message-ID: <1219629045.7890.49.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52564 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYHYBum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:50:42 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1ofhw020050
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:50:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update lpfc driver version to 8.2.8

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2008-08-24 20:50:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2008-08-24 20:51:57.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.2.7"
+#define LPFC_DRIVER_VERSION "8.2.8"
 
 #define LPFC_DRIVER_NAME		"lpfc"
 #define LPFC_SP_DRIVER_HANDLER_NAME	"lpfc:sp"


