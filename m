From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 7/8] V2 ipr: Driver version 2.6.0
Date: Fri, 11 Jan 2013 17:43:53 -0600
Message-ID: <20130111234530.524857714@linux.vnet.ibm.com>
References: <20130111234346.012076652@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:54401 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755675Ab3AKXru (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2013 18:47:50 -0500
Content-Disposition: inline; filename=version_bump
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Bump driver version.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2013-01-11 16:11:50.275910225 -0600
+++ b/drivers/scsi/ipr.h	2013-01-11 16:12:03.673719736 -0600
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
