From: brking@us.ibm.com
Subject: [PATCH 26/26] ipr: Driver version 2.1.0
Date: Tue, 01 Nov 2005 17:03:02 -0600
Message-ID: <200511012303.jA1N32cs020575@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:1768 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751422AbVKAXDE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:03:04 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N34bN009152
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:03:04 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA1N47DC522954
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:04:07 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N339m020598
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:03:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump the driver version.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_1_0 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_driver_version_2_1_0	2005-10-31 15:01:06.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-10-31 15:01:06.000000000 -0600
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.14"
-#define IPR_DRIVER_DATE "(May 2, 2005)"
+#define IPR_DRIVER_VERSION "2.1.0"
+#define IPR_DRIVER_DATE "(October 31, 2005)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_
