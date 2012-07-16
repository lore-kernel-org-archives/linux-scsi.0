From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ipr: Driver version 2.5.4
Date: Mon, 16 Jul 2012 15:48:11 -0500
Message-ID: <201207162048.q6GKmBb4018234@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:46836 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2GPUsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2012 16:48:23 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 16 Jul 2012 14:48:23 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 3B4E519D804E
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 20:48:18 +0000 (WET)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6GKmDQE215846
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 14:48:14 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6GKmD1X018285
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 14:48:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_5_4 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_version_2_5_4	2012-07-11 16:40:34.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2012-07-11 16:40:34.000000000 -0500
@@ -38,8 +38,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.5.3"
-#define IPR_DRIVER_DATE "(March 10, 2012)"
+#define IPR_DRIVER_VERSION "2.5.4"
+#define IPR_DRIVER_DATE "(July 11, 2012)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_

