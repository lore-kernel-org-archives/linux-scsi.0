From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 7/7] RESEND ipr: Driver version 2.6.0
Date: Mon, 03 Dec 2012 12:31:19 -0600
Message-ID: <20121203183212.398005247@linux.vnet.ibm.com>
References: <20121203183112.822371464@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:1370 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1750904Ab2LCSe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 13:34:28 -0500
Content-Disposition: inline; filename=version_bump
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Bump driver version.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2012-11-19 12:18:58.263935158 -0600
+++ b/drivers/scsi/ipr.h	2012-11-19 12:35:31.355166443 -0600
@@ -39,8 +39,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.5.4"
-#define IPR_DRIVER_DATE "(July 11, 2012)"
+#define IPR_DRIVER_VERSION "2.6.0"
+#define IPR_DRIVER_DATE "(November 16, 2012)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding

-- 
