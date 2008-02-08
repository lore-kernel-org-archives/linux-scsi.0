From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/6] lpfc 8.2.5 : Update lpfc driver version to 8.2.5
Date: Fri, 08 Feb 2008 18:50:36 -0500
Message-ID: <1202514636.20924.21.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44748 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbYBHXuX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 18:50:23 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m18NoMxR018635
	for <linux-scsi@vger.kernel.org>; Fri, 8 Feb 2008 15:50:22 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Update lpfc driver version to 8.2.5


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_version.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2008-02-08 18:14:14.000000000 -0500
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.2.4"
+#define LPFC_DRIVER_VERSION "8.2.5"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


