From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ibmvfc: Driver version 1.0.10
Date: Fri, 24 Aug 2012 16:51:03 -0500
Message-ID: <201208242151.q7OLp3O3013247@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48776 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758034Ab2HXVvI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Aug 2012 17:51:08 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 24 Aug 2012 17:51:07 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 3C02EC90046
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:05 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7OLp49T38535228
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7OLp4Xs013303
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcj@linux.vnet.ibm.com, stimmer@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_10 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_10	2012-08-24 16:47:14.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2012-08-24 16:48:45.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.9"
-#define IBMVFC_DRIVER_DATE		"(August 5, 2010)"
+#define IBMVFC_DRIVER_VERSION		"1.0.10"
+#define IBMVFC_DRIVER_DATE		"(August 24, 2012)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_ADISC_CANCEL_TIMEOUT	45
_

