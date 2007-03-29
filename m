From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 12/12] ipr: Driver version to 2.3.2
Date: Thu, 29 Mar 2007 12:43:57 -0500
Message-ID: <200703291743.l2THhvjB001738@d03av02.boulder.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:38379 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030479AbXC2Rn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 13:43:59 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THhxmg021696
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:59 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THhw2u113914
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:58 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THhw8K001821
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:58 -0600
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_3_2 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_driver_version_2_3_2	2007-03-23 15:54:44.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-03-23 15:54:54.000000000 -0500
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.3.1"
-#define IPR_DRIVER_DATE "(January 23, 2007)"
+#define IPR_DRIVER_VERSION "2.3.2"
+#define IPR_DRIVER_DATE "(March 23, 2007)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_
