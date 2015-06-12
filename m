From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ipr: Driver version 2.6.2
Date: Thu, 11 Jun 2015 20:45:22 -0500
Message-ID: <201506120145.t5C1jMYx030031@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:47060 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbFLBp1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2015 21:45:27 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 11 Jun 2015 21:45:26 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8FF4138C8063
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 21:45:24 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5C1jOwg55181534
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 01:45:24 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5C1jNtB030170
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 21:45:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, gbertazi@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_6_2 drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_version_2_6_2	2015-06-11 20:11:35.110136508 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2015-06-11 20:11:45.055050007 -0500
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.6.1"
-#define IPR_DRIVER_DATE "(March 12, 2015)"
+#define IPR_DRIVER_VERSION "2.6.2"
+#define IPR_DRIVER_DATE "(June 11, 2015)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_

