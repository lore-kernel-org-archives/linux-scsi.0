From: Ketan Mukadam <ketan.mukadam@avagotech.com>
Subject: [PATCH 2/2] be2iscsi: Revert ownership to Emulex
Date: Sat,  4 Jul 2015 04:12:33 +0530
Message-ID: <1435963353-29153-1-git-send-email-ketan.mukadam@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55870 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754250AbbGCGQ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 02:16:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Ketan Mukadam <ketan.mukadam@avagotech.com>

We would like to get the following updates in:
    Revert ownership to "Emulex" from "Avago Technologies"

Signed-off-by: Ketan Mukadam <ketan.mukadam@avagotech.com>
---
 drivers/scsi/be2iscsi/Kconfig    | 4 ++--
 drivers/scsi/be2iscsi/Makefile   | 2 +-
 drivers/scsi/be2iscsi/be.h       | 4 ++--
 drivers/scsi/be2iscsi/be_cmds.c  | 4 ++--
 drivers/scsi/be2iscsi/be_cmds.h  | 4 ++--
 drivers/scsi/be2iscsi/be_iscsi.c | 4 ++--
 drivers/scsi/be2iscsi/be_main.c  | 8 ++++----
 drivers/scsi/be2iscsi/be_main.h  | 6 +++---
 drivers/scsi/be2iscsi/be_mgmt.c  | 4 ++--
 drivers/scsi/be2iscsi/be_mgmt.h  | 4 ++--
 10 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/be2iscsi/Kconfig b/drivers/scsi/be2iscsi/Kconfig
index ceaca32..4e7cad2 100644
--- a/drivers/scsi/be2iscsi/Kconfig
+++ b/drivers/scsi/be2iscsi/Kconfig
@@ -1,9 +1,9 @@
 config BE2ISCSI
-	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
+	tristate "Emulex 10Gbps iSCSI - BladeEngine 2"
 	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
 	select ISCSI_BOOT_SYSFS
 
 	help
-	This driver implements the iSCSI functionality for ServerEngines'
+	This driver implements the iSCSI functionality for Emulex
 	10Gbps Storage adapter - BladeEngine 2.
diff --git a/drivers/scsi/be2iscsi/Makefile b/drivers/scsi/be2iscsi/Makefile
index c11f443..d0488ea 100644
--- a/drivers/scsi/be2iscsi/Makefile
+++ b/drivers/scsi/be2iscsi/Makefile
@@ -1,5 +1,5 @@
 #
-# Makefile to build the iSCSI driver for ServerEngine's BladeEngine.
+# Makefile to build the iSCSI driver for Emulex OneConnect.
 #
 #
 
diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 3207009..77f992e 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -10,7 +10,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 185391a..2778089 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -10,7 +10,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index cdfbc5c..4bfca35 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -10,7 +10,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 2f07007..b7087ba 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -12,7 +12,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7a6dbfb..2e6abe7 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -12,7 +12,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
@@ -50,7 +50,7 @@ static unsigned int enable_msix = 1;
 
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
 MODULE_VERSION(BUILD_STR);
-MODULE_AUTHOR("Avago Technologies");
+MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
 module_param(be_iopoll_budget, int, 0);
 module_param(enable_msix, int, 0);
@@ -552,7 +552,7 @@ MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 
 static struct scsi_host_template beiscsi_sht = {
 	.module = THIS_MODULE,
-	.name = "Avago Technologies 10Gbe open-iscsi Initiator Driver",
+	.name = "Emulex 10Gbe open-iscsi Initiator Driver",
 	.proc_name = DRV_NAME,
 	.queuecommand = iscsi_queuecommand,
 	.change_queue_depth = scsi_change_queue_depth,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index b8c0c78..51366de 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -12,7 +12,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
@@ -37,7 +37,7 @@
 
 #define DRV_NAME		"be2iscsi"
 #define BUILD_STR		"10.6.0.0"
-#define BE_NAME			"Avago Technologies OneConnect" \
+#define BE_NAME			"Emulex OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index ca4016f..1b2bd04 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -12,7 +12,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index b58a7de..afa326d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2015 Avago Technologies
+ * Copyright (C) 2005 - 2015 Emulex
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -12,7 +12,7 @@
  * Contact Information:
  * linux-drivers@avagotech.com
  *
- * Avago Technologies
+ * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
-- 
1.8.3.1

