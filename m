From: brking@us.ibm.com
Subject: [PATCH 15/15] ipr: Bump driver version to 2.0.13
Date: Mon, 21 Feb 2005 15:10:01 -0600
Message-ID: <200502212110.j1LLA2Wa002503@d03av02.boulder.ibm.com>
Received: from e35.co.us.ibm.com ([32.97.110.133]:7402 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262135AbVBUVKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:10:05 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LLA3Lg385794
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:10:03 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LLA38D105158
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:10:03 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LLA3FR002526
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:10:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump the driver version to 2.0.13

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_0_13 drivers/scsi/ipr.h
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.h~ipr_driver_version_2_0_13	2005-02-21 13:17:51.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.h	2005-02-21 13:18:12.000000000 -0600
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.12"
-#define IPR_DRIVER_DATE "(December 14, 2004)"
+#define IPR_DRIVER_VERSION "2.0.13"
+#define IPR_DRIVER_DATE "(February 21, 2005)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing
_
