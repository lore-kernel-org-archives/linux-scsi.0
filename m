From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 6/6] ibmvfc: Driver version 1.0.7
Date: Mon, 19 Oct 2009 15:07:55 -0500
Message-ID: <200910192007.n9JK7tDX000304@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38538 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411AbZJSUHw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2009 16:07:52 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e8.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JK4ou8014368
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 16:04:50 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JK7uhB196764
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 16:07:56 -0400
Received: from d01av01.pok.ibm.com (d03av01 [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9JK7tfg000327
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 16:07:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version to 1.0.7.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_7 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_7	2009-10-16 16:22:14.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2009-10-16 16:22:26.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.6"
-#define IBMVFC_DRIVER_DATE		"(May 28, 2009)"
+#define IBMVFC_DRIVER_VERSION		"1.0.7"
+#define IBMVFC_DRIVER_DATE		"(October 16, 2009)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_ADISC_CANCEL_TIMEOUT	45
_
