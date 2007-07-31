From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/8] lpfc 8.2.2 : Change version number to 8.2.2
Date: Tue, 31 Jul 2007 21:28:02 +0000 (UTC)
Message-ID: <1186067446.14374.28.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50156 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764941AbXGaV1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:27:01 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQnis028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:27:00 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:10:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change version number to 8.2.2


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2007-08-02 07:07:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2007-08-02 09:13:52.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.2.1"
+#define LPFC_DRIVER_VERSION "8.2.2"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


