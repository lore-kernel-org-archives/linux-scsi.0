From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ibmvfc: Update driver version to 1.0.1
Date: Tue, 22 Jul 2008 08:31:48 -0500
Message-ID: <200807221332.m6MDWAUl009221@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43489 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYGVNcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jul 2008 09:32:11 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6MDWBOR015678
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 09:32:11 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6MDWBZZ041886
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 09:32:11 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6MDWAVZ009243
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 09:32:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Update driver version to 1.0.1.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_1 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_1	2008-07-11 16:31:23.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-07-11 16:31:33.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.0"
-#define IBMVFC_DRIVER_DATE		"(July 1, 2008)"
+#define IBMVFC_DRIVER_VERSION		"1.0.1"
+#define IBMVFC_DRIVER_DATE		"(July 11, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	15
 #define IBMVFC_INIT_TIMEOUT		30
_
