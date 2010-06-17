From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ibmvfc: Driver version 1.0.8
Date: Thu, 17 Jun 2010 13:55:16 -0500
Message-ID: <201006171855.o5HItG20008706@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:34433 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab0FQSzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:55:35 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HIkNXA021734
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:46:23 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5HItJtX100298
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:55:22 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HItHNt008789
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:55:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_8 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_version_1_0_8	2010-06-17 12:45:07.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2010-06-17 12:45:19.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.7"
-#define IBMVFC_DRIVER_DATE		"(October 16, 2009)"
+#define IBMVFC_DRIVER_VERSION		"1.0.8"
+#define IBMVFC_DRIVER_DATE		"(June 17, 2010)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_ADISC_CANCEL_TIMEOUT	45
_
