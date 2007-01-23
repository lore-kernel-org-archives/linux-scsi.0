From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/4] ipr: Driver version 2.3.1
Date: Tue, 23 Jan 2007 11:25:43 -0600
Message-ID: <200701231725.l0NHPhGC030059@d03av02.boulder.ibm.com>
References: <1169573123318-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43699 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965140AbXAWRZp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 12:25:45 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0NHPj7L008507
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 12:25:45 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0NHPjW5555054
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 10:25:45 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0NHPje6030125
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 10:25:45 -0700
In-Reply-To: <1169573123318-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brazilnut@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version to 2.3.1.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_3_1 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_driver_version_2_3_1	2007-01-23 11:01:15.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-01-23 11:24:28.000000000 -0600
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.3.0"
-#define IPR_DRIVER_DATE "(November 8, 2006)"
+#define IPR_DRIVER_VERSION "2.3.1"
+#define IPR_DRIVER_DATE "(January 23, 2007)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_
