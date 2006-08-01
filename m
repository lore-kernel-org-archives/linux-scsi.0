From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/6] lpfc 8.1.7 : Change version number to 8.1.8
Date: Tue, 01 Aug 2006 07:34:16 -0400
Message-ID: <1154432056.18162.17.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:3529 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932669AbWHALeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 07:34:19 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k71BYIm1000902
	for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2006 04:34:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change version number to 8.1.8

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2006-07-31 10:41:15.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2006-08-01 07:20:04.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.1.7"
+#define LPFC_DRIVER_VERSION "8.1.8"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


