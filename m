From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/5] ibmvfc: Driver version 1.0.5
Date: Fri, 20 Mar 2009 15:44:40 -0500
Message-ID: <200903202044.n2KKiaM8006541@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59131 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbZCTUoj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2009 16:44:39 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2KKfbNU012422
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 16:41:37 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2KKibv1172580
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 16:44:37 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2KKiaB2006659
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 16:44:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version to 1.0.5.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_5 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_5	2009-03-19 15:25:35.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-03-19 15:25:49.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.4"
-#define IBMVFC_DRIVER_DATE		"(November 14, 2008)"
+#define IBMVFC_DRIVER_VERSION		"1.0.5"
+#define IBMVFC_DRIVER_DATE		"(March 19, 2009)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_ADISC_CANCEL_TIMEOUT	45
_
