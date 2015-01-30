From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: Driver version 2.6.1
Date: Fri, 30 Jan 2015 16:30:59 -0600
Message-ID: <201501302231.t0UMVGDk022759@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:38184 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbA3Wbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jan 2015 17:31:45 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 30 Jan 2015 15:31:44 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 41CB419D8040
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2015 15:22:52 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0UMUK3f20250786
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2015 15:30:20 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0UMVG0T023400
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2015 15:31:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_6_1 drivers/scsi/ipr.h
--- scsi-queue/drivers/scsi/ipr.h~ipr_version_2_6_1	2015-01-14 10:28:14.227130049 -0600
+++ scsi-queue-bjking1/drivers/scsi/ipr.h	2015-01-30 16:25:07.005173771 -0600
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.6.0"
-#define IPR_DRIVER_DATE "(November 16, 2012)"
+#define IPR_DRIVER_VERSION "2.6.1"
+#define IPR_DRIVER_DATE "(January 30, 2015)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_

