From: Brian King <brking@us.ibm.com>
Subject: [PATCH 5/5] ipr: Bump driver version to 2.1.4
Date: Wed, 02 Aug 2006 14:58:04 -0500
Message-ID: <200608021958.k72Jw5qO021019@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:10667 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932206AbWHBT6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 15:58:08 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k72Jw6YY008778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:58:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k72Jw6M8253310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:58:06 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k72Jw6tp021058
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 15:58:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump the ipr driver version to 2.1.4.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_1_4 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_driver_version_2_1_4	2006-08-02 13:58:43.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2006-08-02 13:58:55.000000000 -0500
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.1.3"
-#define IPR_DRIVER_DATE "(March 29, 2006)"
+#define IPR_DRIVER_VERSION "2.1.4"
+#define IPR_DRIVER_DATE "(August 2, 2006)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_
