From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 6/6] ipr: Driver version 2.5.3
Date: Wed, 14 Mar 2012 21:20:12 -0500
Message-ID: <201203150220.q2F2K8eb003089@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56560 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab2COCUc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 22:20:32 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 14 Mar 2012 20:20:31 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 012CD3E40036
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:12 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2F2KBqX170140
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2F2KAQq003135
	for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 20:20:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Bump driver version

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_5_3 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_version_2_5_3	2012-03-10 13:48:03.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2012-03-10 13:48:03.000000000 -0600
@@ -38,8 +38,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.5.2"
-#define IPR_DRIVER_DATE "(April 27, 2011)"
+#define IPR_DRIVER_VERSION "2.5.3"
+#define IPR_DRIVER_DATE "(March 10, 2012)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_

