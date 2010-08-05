From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ibmvfc: Driver version 1.0.9
Date: Thu, 05 Aug 2010 16:38:36 -0500
Message-ID: <201008052138.o75LcZxF013073@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53923 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab0HEVim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 17:38:42 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o75LR84f027092
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:27:08 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o75LcbXK157810
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:38:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o75Lcaaa013150
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:38:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_version_1_0_9 drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_driver_version_1_0_9	2010-08-05 16:33:59.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2010-08-05 16:35:20.000000000 -0500
@@ -29,8 +29,8 @@
 #include "viosrp.h"
 
 #define IBMVFC_NAME	"ibmvfc"
-#define IBMVFC_DRIVER_VERSION		"1.0.8"
-#define IBMVFC_DRIVER_DATE		"(June 17, 2010)"
+#define IBMVFC_DRIVER_VERSION		"1.0.9"
+#define IBMVFC_DRIVER_DATE		"(August 5, 2010)"
 
 #define IBMVFC_DEFAULT_TIMEOUT	60
 #define IBMVFC_ADISC_CANCEL_TIMEOUT	45
_
