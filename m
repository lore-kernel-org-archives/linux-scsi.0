From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ibmvfc: Driver version 1.0.2
Date: Fri, 15 Aug 2008 10:59:28 -0500
Message-ID: <200808151600.m7FG0AUt010042@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46296 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbYHOQAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 12:00:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FG0BHv021725
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:11 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FG0BRZ165204
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:11 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FG0AOD010087
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version to 1.0.2.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_2 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_1_0_2	2008-08-14 13:54:25.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-08-14 13:54:35.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.1"
-#define IBMVFC_DRIVER_DATE		"(July 11, 2008)"
+#define IBMVFC_DRIVER_VERSION		"1.0.2"
+#define IBMVFC_DRIVER_DATE		"(August 14, 2008)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	15
 #define IBMVFC_INIT_TIMEOUT		30
_
