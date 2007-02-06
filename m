From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 5/5] scsi: megaraid_sas - update version and author info
Date: Tue, 06 Feb 2007 14:24:59 -0800
Message-ID: <1170800699.10482.46.camel@dumbo>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ie6699aZ9uIRkAuoL5XU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34625 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965635AbXBGDfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Feb 2007 22:35:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


--=-ie6699aZ9uIRkAuoL5XU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Update version and author information.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |    8 +++++---
 drivers/scsi/megaraid/megaraid_sas.h |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:12:42.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:20:10.000000000 -0800
@@ -10,11 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.05
+ * Version	: v00.00.03.09-rc1
  *
  * Authors:
- * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsi.com>
- * 	Sumant Patro		<Sumant.Patro@lsi.com>
+ *	(email-id : megaraidlinux@lsi.com)
+ * 	Sreenivas Bagalkote
+ * 	Sumant Patro
+ *	Bo Yang
  *
  * List of supported controllers
  *
diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 10:14:17.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 13:03:55.000000000 -0800
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.05"
-#define MEGASAS_RELDATE				"Oct 02, 2006"
-#define MEGASAS_EXT_VERSION			"Mon Oct 02 11:21:32 PDT 2006"
+#define MEGASAS_VERSION				"00.00.03.09-rc1"
+#define MEGASAS_RELDATE				"Feb 06, 2007"
+#define MEGASAS_EXT_VERSION			"Tue Feb 06 12:35:46 PST 2007"
 
 /*
  * Device IDs


--=-ie6699aZ9uIRkAuoL5XU
Content-Disposition: attachment; filename=p5-update-vers.patch
Content-Type: text/x-patch; name=p5-update-vers.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:12:42.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 13:20:10.000000000 -0800
@@ -10,11 +10,13 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.05
+ * Version	: v00.00.03.09-rc1
  *
  * Authors:
- * 	Sreenivas Bagalkote	<Sreenivas.Bagalkote@lsi.com>
- * 	Sumant Patro		<Sumant.Patro@lsi.com>
+ *	(email-id : megaraidlinux@lsi.com)
+ * 	Sreenivas Bagalkote
+ * 	Sumant Patro
+ *	Bo Yang
  *
  * List of supported controllers
  *
diff -uprN 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p4/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 10:14:17.000000000 -0800
+++ 2.6.new-p5/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 13:03:55.000000000 -0800
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.05"
-#define MEGASAS_RELDATE				"Oct 02, 2006"
-#define MEGASAS_EXT_VERSION			"Mon Oct 02 11:21:32 PDT 2006"
+#define MEGASAS_VERSION				"00.00.03.09-rc1"
+#define MEGASAS_RELDATE				"Feb 06, 2007"
+#define MEGASAS_EXT_VERSION			"Tue Feb 06 12:35:46 PST 2007"
 
 /*
  * Device IDs

--=-ie6699aZ9uIRkAuoL5XU--

