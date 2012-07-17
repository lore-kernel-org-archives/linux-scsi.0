From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 3/3] ipr: Driver version 2.5.4
Date: Tue, 17 Jul 2012 08:15:33 -0500
Message-ID: <201207171316.q6HDGjlG021108@d03av05.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37845 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2GQNRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 09:17:46 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 17 Jul 2012 07:17:45 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id DC5ED3E40054
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 13:17:07 +0000 (WET)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6HDGt3m093442
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 07:17:00 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6HDGkNv021195
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 07:16:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


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

