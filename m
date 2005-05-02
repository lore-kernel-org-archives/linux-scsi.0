From: brking@us.ibm.com
Subject: [PATCH 3/3] ipr: Driver version 2.0.14
Date: Mon, 02 May 2005 14:51:06 -0500
Message-ID: <200505021951.j42Jp6BV030453@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:62409 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261739AbVEBTvI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2005 15:51:08 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j42Jp73r028005
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 15:51:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j42Jp78e065028
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 15:51:07 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j42Jp7Og030466
	for <linux-scsi@vger.kernel.org>; Mon, 2 May 2005 15:51:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump driver version

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.12-rc3-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_0_14 drivers/scsi/ipr.h
--- linux-2.6.12-rc3/drivers/scsi/ipr.h~ipr_driver_version_2_0_14	2005-05-02 14:33:37.000000000 -0500
+++ linux-2.6.12-rc3-bjking1/drivers/scsi/ipr.h	2005-05-02 14:33:44.000000000 -0500
@@ -36,8 +36,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.0.13"
-#define IPR_DRIVER_DATE "(February 21, 2005)"
+#define IPR_DRIVER_VERSION "2.0.14"
+#define IPR_DRIVER_DATE "(May 2, 2005)"
 
 /*
  * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing
_
