From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/9] lpfc 8.2.3 : Change version number to 8.2.3
Date: Sat, 27 Oct 2007 13:38:20 -0400
Message-ID: <1193506700.8770.30.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46382 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXJ0RiO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Oct 2007 13:38:14 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l9RHcDnn021405
	for <linux-scsi@vger.kernel.org>; Sat, 27 Oct 2007 10:38:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change version number to 8.2.3

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
--- a/drivers/scsi/lpfc/lpfc_version.h	2007-08-18 10:49:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_version.h	2007-10-27 13:21:37.000000000 -0400
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.2.2"
+#define LPFC_DRIVER_VERSION "8.2.3"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


