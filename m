From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/4] lpfc 8.2.6 : Update lpfc driver version to 8.2.6
Date: Mon, 07 Apr 2008 10:16:10 -0400
Message-ID: <1207577770.28169.16.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33305 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbYDGOQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 10:16:12 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m37EGAVo010305
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2008 07:16:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update lpfc driver version to 8.2.6


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2008-02-22 15:59:03.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2008-04-07 09:16:05.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.2.5"
+#define LPFC_DRIVER_VERSION "8.2.6"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


