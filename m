From: brking@us.ibm.com
Subject: [PATCH 6/6] ipr: Bump driver version to 2.0.12
Date: Tue, 14 Dec 2004 17:10:15 -0600
Message-ID: <200412142310.iBENAGmC022333@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:2958 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261757AbULNXSF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 18:18:05 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id iBENI2Dr008036
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:18:02 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBENI2YB455876
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:18:02 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id iBENG0KV029011
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 16:18:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump driver version

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_0_12 drivers/scsi/ipr.h
--- linux-2.6.10-rc3-bk8/drivers/scsi/ipr.h~ipr_driver_version_2_0_12	2004-12-14 17:09:02.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h	2004-12-14 17:09:02.000000000 -0600
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.11"
-#define IPR_DRIVER_DATE "(August 3, 2004)"
+#define IPR_DRIVER_VERSION "2.0.12"
+#define IPR_DRIVER_DATE "(December 14, 2004)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing
_
