From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ipr: Driver version 2.6.1
Date: Thu, 26 Mar 2015 11:24:00 -0500
Message-ID: <201503261624.t2QGO0AY014263@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:56582 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbCZQYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 12:24:07 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 26 Mar 2015 10:24:06 -0600
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 00947C90041
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 12:15:14 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2QGO4KW25428096
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 16:24:04 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2QGO30e014510
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 12:24:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_6_1 drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_version_2_6_1	2015-03-12 16:27:14.235168394 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2015-03-12 16:27:38.294920049 -0500
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.6.0"
-#define IPR_DRIVER_DATE "(November 16, 2012)"
+#define IPR_DRIVER_VERSION "2.6.1"
+#define IPR_DRIVER_DATE "(March 12, 2015)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_

