From: brking@us.ibm.com
Subject: [PATCH 16/16] ipr: Bump driver version.
Date: Wed, 04 Aug 2004 17:33:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042234.i74MYQCu132434@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:51083 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267478AbUHDWdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:33:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump driver version.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_0_11 drivers/scsi/ipr.h
--- linux-2.6.8-rc3/drivers/scsi/ipr.h~ipr_driver_version_2_0_11	2004-08-04 17:17:43.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h	2004-08-04 17:17:43.000000000 -0500
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.10"
-#define IPR_DRIVER_DATE "(June 7, 2004)"
+#define IPR_DRIVER_VERSION "2.0.11"
+#define IPR_DRIVER_DATE "(August 3, 2004)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing
_
