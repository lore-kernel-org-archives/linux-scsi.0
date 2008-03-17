From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 4/4] scsi: megaraid_sas - Update the Version and Changelog
Date: Mon, 17 Mar 2008 04:18:17 -0400
Message-ID: <1205741897.7479.22.camel@pcp021067pcs.se.lsil.com>
References: <9738BCBE884FDB42801FAD8A7769C26501CE50E4@NAMAIL1.ad.lsil.com>
	 <1195251505.3407.30.camel@localhost.localdomain>
	 <9738BCBE884FDB42801FAD8A7769C26501C9A4AF@NAMAIL1.ad.lsil.com>
	 <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51640 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbYCQUin (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 16:38:43 -0400
In-Reply-To: <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, neela.kolli@lsi.com, bo.yang@lsi.com

Update the Version and ChangeLog

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 Documentation/scsi/ChangeLog.megaraid_sas |   22 ++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 -
 drivers/scsi/megaraid/megaraid_sas.h      |    6 ++---
 3 files changed, 26 insertions(+), 4 deletions(-)

diff -rupN linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas	2008-03-10 10:17:25.000000000 -0400
+++ linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas	2008-03-10 10:41:39.000000000 -0400
@@ -3,6 +3,28 @@
 			Sumant Patro
 			Bo Yang
 
+2 Current Version : 00.00.03.20
+3 Older Version   : 00.00.03.16
+
+1. Sense buffer ptr data type in the ioctl path is reverted  back to
+	u32 * as in previous versions of driver.
+
+2. Fixed the driver frame count.
+	When Driver sent wrong frame count to firmware.  As this particular
+	command is sent to drive, FW is seeing continuous chip resets and so
+	the command will timeout.
+
+3. Add the new controller(1078DE) support to the driver.
+
+4. Increase the max_wait to 60 from 10 in the controller operational status.
+	With this max_wait increase, driver will make sure the FW will finish
+	the pending cmd for KDUMP case.   
+
+1 Release Date    : Thur. Nov. 07 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+
 2 Current Version : 00.00.03.16
 3 Older Version   : 00.00.03.15
 
diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c	2008-03-17 13:54:59.000000000 -0400
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c	2008-03-17 13:55:30.000000000 -0400
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.16-rc1
+ * Version	: v00.00.03.20-rc1
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.h	2008-03-10 10:17:25.000000000 -0400
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.h	2008-03-10 10:51:02.000000000 -0400
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.16-rc1"
-#define MEGASAS_RELDATE				"Nov. 07, 2007"
-#define MEGASAS_EXT_VERSION			"Thu. Nov. 07 10:09:32 PDT 2007"
+#define MEGASAS_VERSION			"00.00.03.20-rc1"
+#define MEGASAS_RELDATE			"March 10, 2008"
+#define MEGASAS_EXT_VERSION		"Mon. March 10 11:02:31 PDT 2008"
 
 /*
  * Device IDs

