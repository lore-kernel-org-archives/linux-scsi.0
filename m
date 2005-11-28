From: James.Smart@Emulex.Com
Subject: [PATCH 11/11]  lpfc 8.1.1 : Change version number to 8.1.1
Date: Mon, 28 Nov 2005 11:42:49 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4F@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49397 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751300AbVK1Qmw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:42:52 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGgos3014177
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:42:51 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Change version number to 8.1.1


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2005-11-28 10:36:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_version.h	2005-11-28 11:09:48.000000000 -0500
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.1.0"
+#define LPFC_DRIVER_VERSION "8.1.1"
 
 #define LPFC_DRIVER_NAME "lpfc"
 
