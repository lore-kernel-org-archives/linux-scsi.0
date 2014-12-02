From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH RESEND 5/5] ipr: Driver version 2.6.1
Date: Tue, 02 Dec 2014 12:47:49 -0600
Message-ID: <201412021847.sB2IloUm009132@d03av05.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41759 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaLBSr4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 13:47:56 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 11:47:56 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id E49D63E40040
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 11:47:52 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2ImIwC27656266
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 11:48:18 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2Ilpwr009254
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 11:47:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, anton@samba.org, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_6_1 drivers/scsi/ipr.h
--- scsi-queue/drivers/scsi/ipr.h~ipr_version_2_6_1	2014-12-02 12:25:20.232176757 -0600
+++ scsi-queue-bjking1/drivers/scsi/ipr.h	2014-12-02 12:43:38.004935750 -0600
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.6.0"
-#define IPR_DRIVER_DATE "(November 16, 2012)"
+#define IPR_DRIVER_VERSION "2.6.1"
+#define IPR_DRIVER_DATE "(December 2, 2014)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_

