From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/5] ipr: Driver version 2.6.1
Date: Mon, 28 Jul 2014 15:30:22 -0500
Message-ID: <53D6B2DE.6050502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37491 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaG1Ua2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 16:30:28 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 28 Jul 2014 16:30:27 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 0920F6E801A
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 16:30:14 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22036.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s6SKUOEN61341880
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 20:30:24 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s6SKUNe7032047
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2014 16:30:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_6_1 drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_version_2_6_1	2014-07-25 11:27:33.840128017 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2014-07-25 11:27:33.844127959 -0500
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.6.0"
-#define IPR_DRIVER_DATE "(November 16, 2012)"
+#define IPR_DRIVER_VERSION "2.6.1"
+#define IPR_DRIVER_DATE "(July 24, 2014)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_

