From: Brian King <brking@us.ibm.com>
Subject: [PATCH 10/10] ipr: Driver version 2.3.0
Date: Tue, 21 Nov 2006 10:28:55 -0600
Message-ID: <200611211628.kALGStSm028541@d01av03.pok.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:11657 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1031092AbWKUQab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:30:31 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGUM06025598
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:30:22 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGSuOl196260
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:56 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGStDf028558
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:56 -0500
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Bump driver version.

---

 linux-2.6-bjking1/drivers/scsi/ipr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_driver_version_2_3_0 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_driver_version_2_3_0	2006-11-15 15:43:19.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2006-11-15 15:43:19.000000000 -0600
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.2.0"
-#define IPR_DRIVER_DATE "(September 25, 2006)"
+#define IPR_DRIVER_VERSION "2.3.0"
+#define IPR_DRIVER_DATE "(November 8, 2006)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
_
