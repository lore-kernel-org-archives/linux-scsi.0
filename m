From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/5] lpfc 8.2.7 : Update version to 8.2.7
Date: Sat, 14 Jun 2008 22:53:02 -0400
Message-ID: <1213498382.10002.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33095 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbYFOCxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jun 2008 22:53:05 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m5F2r4ia018805
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jun 2008 19:53:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc driver version to 8.2.7


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2008-06-14 22:39:46.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.2.6"
+#define LPFC_DRIVER_VERSION "8.2.7"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


