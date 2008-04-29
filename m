From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 1/1] scsi: megaraid_sas - Update the Version and Changelog
Date: Tue, 29 Apr 2008 03:55:33 -0400
Message-ID: <1209455733.7393.12.camel@pcp021469pcs.se.lsil.com>
References: <1191253256.5850.4.camel@dhcp-75-534.se.lsil.com>
	 <9738BCBE884FDB42801FAD8A7769C265010A0A09@NAMAIL1.ad.lsil.com>
	 <1193764692.3321.88.camel@localhost.localdomain>
	 <9738BCBE884FDB42801FAD8A7769C265010A0A11@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60010 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYD2USD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 16:18:03 -0400
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265010A0A11@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>, bo.yang@lsi.com

Update the Version and Changelog for megaraid_sas Driver

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 Documentation/scsi/ChangeLog.megaraid_sas |   22 ++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 -
 drivers/scsi/megaraid/megaraid_sas.h      |    6 ++---
 3 files changed, 26 insertions(+), 4 deletions(-)

diff -rupN linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas	2008-04-22 22:36:07.000000000 -0400
+++ linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas	2008-04-29 03:47:24.000000000 -0400
@@ -1,3 +1,25 @@
+1 Release Date    : Mon. March 10 11:02:31 PDT 2008 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+
+2 Current Version : 00.00.03.20-RC1
+3 Older Version   : 00.00.03.16
+
+1. Rollback the sense info implementation
+	Sense buffer ptr data type in the ioctl path is reverted back
+	to u32 * as in previous versions of driver.
+
+2. Fixed the driver frame count.
+	When Driver sent wrong frame count to firmware.  As this
+	particular command is sent to drive, FW is seeing continuous
+	chip resets and so the command will timeout.
+
+3. Add the new controller(1078DE) support to the driver
+	and Increase the max_wait to 60 from 10 in the controller
+	operational status.  With this max_wait increase, driver will
+	make sure the FW will 	finish the pending cmd for KDUMP case.
+
 1 Release Date    : Thur. Nov. 07 16:30:43 PST 2007 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Sumant Patro
diff -rupN linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.c	2008-04-22 22:36:07.000000000 -0400
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.c	2008-04-22 22:36:07.000000000 -0400
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
--- linux-2.6.24_orig/drivers/scsi/megaraid/megaraid_sas.h	2008-04-22 22:36:07.000000000 -0400
+++ linux-2.6.24_new/drivers/scsi/megaraid/megaraid_sas.h	2008-04-22 22:36:07.000000000 -0400
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

