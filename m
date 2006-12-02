From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/9] lpfc 8.1.11 :  Change version number to 8.1.11
Date: Sat, 02 Dec 2006 13:36:04 -0500
Message-ID: <1165084565.27443.30.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57815 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1163046AbWLBQHJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:09 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71at009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change version number to 8.1.11

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2006-12-02 12:42:05.000000000 -0500
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.1.10"
+#define LPFC_DRIVER_VERSION "8.1.11"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


