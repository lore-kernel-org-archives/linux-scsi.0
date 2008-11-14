From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ibmvfc: Driver version 1.0.4
Date: Fri, 14 Nov 2008 13:33:54 -0600
Message-ID: <200811141934.mAEJYN6D013407@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51374 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbYKNTe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2008 14:34:28 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAEJXIZY005488
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:33:18 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAEJYPFs133236
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:34:26 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAEJYOBg013448
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:34:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_4 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_4	2008-11-14 11:09:42.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-11-14 11:09:54.000000000 -0600
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.3"
-#define IBMVFC_DRIVER_DATE		"(October 28, 2008)"
+#define IBMVFC_DRIVER_VERSION		"1.0.4"
+#define IBMVFC_DRIVER_DATE		"(November 14, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	15
 #define IBMVFC_INIT_TIMEOUT		30
_
