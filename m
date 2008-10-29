From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ibmvfc: Driver version 1.0.3
Date: Wed, 29 Oct 2008 08:46:49 -0500
Message-ID: <200810291347.m9TDlHha003225@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45600 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbYJ2NrT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 09:47:19 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m9TDlJHd001630
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 09:47:19 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9TDlIRI130126
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 09:47:18 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9TDlIgr003254
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 09:47:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_3 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_3	2008-10-28 15:52:35.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-10-28 15:52:51.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.2"
-#define IBMVFC_DRIVER_DATE		"(August 14, 2008)"
+#define IBMVFC_DRIVER_VERSION		"1.0.3"
+#define IBMVFC_DRIVER_DATE		"(October 28, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	15
 #define IBMVFC_INIT_TIMEOUT		30
_
