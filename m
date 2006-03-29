From: Brian King <brking@us.ibm.com>
Subject: [PATCH 6/6] ipr: Bump version
Date: Wed, 29 Mar 2006 09:37:49 -0600
Message-ID: <200603291537.k2TFbon7009568@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:8395 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751184AbWC2Phw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:37:52 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2TFbpXk010618
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:51 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2TFbp6F190600
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:51 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2TFboWE009610
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump ipr driver version to 2.1.3

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_version_2_1_3 drivers/scsi/ipr.h
--- libata-dev/drivers/scsi/ipr.h~ipr_version_2_1_3	2006-03-29 09:19:04.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-03-29 09:19:15.000000000 -0600
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.1.2"
-#define IPR_DRIVER_DATE "(February 8, 2006)"
+#define IPR_DRIVER_VERSION "2.1.3"
+#define IPR_DRIVER_DATE "(March 29, 2006)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_
