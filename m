From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/5] ibmvfc: Driver version 1.0.11
Date: Fri, 12 Apr 2013 08:25:19 -0500
Message-ID: <201304121325.r3CDPJIQ025089@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58982 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab3DLNZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 09:25:23 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 12 Apr 2013 09:25:22 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id B5BDF6E8044
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:17 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3CDPK4I304272
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:20 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3CDPJ5G025119
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcjenn@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com


Bump driver version to 1.0.11.


Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_11 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_11	2013-04-10 15:51:55.000000000 -0500
+++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2013-04-12 08:22:33.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.10"
-#define IBMVFC_DRIVER_DATE		"(August 24, 2012)"
+#define IBMVFC_DRIVER_VERSION		"1.0.11"
+#define IBMVFC_DRIVER_DATE		"(April 12, 2013)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_ADISC_CANCEL_TIMEOUT	45
_

