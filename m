From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 15/15] lpfc 8.1.7 : Change version number to 8.1.7
Date: Thu, 06 Jul 2006 15:50:58 -0400
Message-ID: <1152215458.23158.32.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34188 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750786AbWGFTum
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:50:42 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JoeWa007001
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:50:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change version number to 8.1.7

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2006-07-06 15:09:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2006-07-06 15:10:58.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.1.6"
+#define LPFC_DRIVER_VERSION "8.1.7"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


