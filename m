From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 12/12] megaraid_sas : Changelog and driver version update
Date: Wed, 22 May 2013 12:36:17 +0530
Message-ID: <201305221236.r4MCaXt6013120@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:9630
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981Ab3EVMvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:51:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

This patch updates the megaraid_sas driver version and updates Documentation/scsi/ChangeLog.megaraid_sas.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/Documentation/scsi/ChangeLog.megaraid_sas b/Documentation/scsi/ChangeLog.megaraid_sas
index 09673c7..cc92ca8 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -1,3 +1,25 @@
+Release Date    : Wed. May 15, 2013 17:00:00 PST 2013 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+			Kashyap Desai
+			Sumit Saxena
+Current Version : 06.600.18.00-rc1
+Old Version     : 06.506.00.00-rc1
+    1. Return DID_ERROR for scsi io, when controller is in critical h/w error.
+    2. Fix the interrupt mask for Gen2 controller.
+    3. Update balance count in driver to be in sync of firmware.
+    4. Free event detail memory without device ID check.
+    5. Set IO request timeout value provided by OS timeout for Tape devices.
+    6. Add support for MegaRAID Fury (device ID-0x005f) 12Gb/s controllers.
+    7. Add support to display Customer branding details in syslog.
+    8. Set IoFlags to enable Fast Path for JBODs for Invader/Fury(12 Gb/s)
+    controllers.
+    9. Add support for Extended MSI-x vectors for Invader and Fury(12Gb/s
+    HBA).
+    10.Add support for Uneven Span PRL11.
+    11.Add support to differentiate between iMR and MR Firmware.
+    12.Version and Changelog update.
+-------------------------------------------------------------------------------
 Release Date    : Sat. Feb 9, 2013 17:00:00 PST 2013 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 408d254..89f11be 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.506.00.00-rc1"
-#define MEGASAS_RELDATE				"Feb. 9, 2013"
-#define MEGASAS_EXT_VERSION			"Sat. Feb. 9 17:00:00 PDT 2013"
+#define MEGASAS_VERSION				"06.600.18.00-rc1"
+#define MEGASAS_RELDATE				"May. 15, 2013"
+#define MEGASAS_EXT_VERSION			"Wed. May. 15 17:00:00 PDT 2013"
 
 /*
  * Device IDs
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9d53540..171811e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v06.506.00.00-rc1
+ *  Version : 06.600.18.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote

