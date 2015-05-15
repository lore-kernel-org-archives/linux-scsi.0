From: Minh Tran <minhduc.tran@avagotech.com>
Subject: [PATCH] be2iscsi change of ownership from Emulex to Avago Technologies recently.  We like to get the following updates in:   changed "Emulex" to "Avago Technologies",   changed email addresses from "emulex.com" to "avagotech.com",   updated MAINTAINER list for be2iscsi driver.
Date: Thu, 14 May 2015 23:16:17 -0700
Message-ID: <1431670577-4125-1-git-send-email-minh.tran@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33957 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061AbbEOGRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 02:17:15 -0400
Received: by ieczm2 with SMTP id zm2so21734360iec.1
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2015 23:17:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Minh Tran <minh.tran@avagotech.com>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>

Signed-off-by: Minh Tran <minh.tran@avagotech.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>
---
 MAINTAINERS                      |  6 ++++--
 drivers/scsi/be2iscsi/be.h       |  6 +++---
 drivers/scsi/be2iscsi/be_cmds.c  |  6 +++---
 drivers/scsi/be2iscsi/be_cmds.h  |  6 +++---
 drivers/scsi/be2iscsi/be_iscsi.c |  8 ++++----
 drivers/scsi/be2iscsi/be_iscsi.h |  8 ++++----
 drivers/scsi/be2iscsi/be_main.c  | 12 ++++++------
 drivers/scsi/be2iscsi/be_main.h  | 10 +++++-----
 drivers/scsi/be2iscsi/be_mgmt.c  |  8 ++++----
 drivers/scsi/be2iscsi/be_mgmt.h  |  8 ++++----
 10 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 590304b..cdb38bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8810,9 +8810,11 @@ F:	drivers/misc/phantom.c
 F:	include/uapi/linux/phantom.h
 
 SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
-M:	Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
+M:	Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>
+M:	Minh Tran <minh.tran@avagotech.com>
+M:	John Soni Jose <sony.john-n@avagotech.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://www.emulex.com
+W:	http://www.avagotech.com
 S:	Supported
 F:	drivers/scsi/be2iscsi/
 
diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
index 81e83a6..3207009 100644
--- a/drivers/scsi/be2iscsi/be.h
+++ b/drivers/scsi/be2iscsi/be.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,9 +8,9 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1028760..447cf7c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,9 +8,9 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 98897434..f11d325 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -8,9 +8,9 @@
  * Public License is included in this distribution in the file called COPYING.
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index b7391a3..f38e46f 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies 
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index e0b3b2d..0c84e1c 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 923a2b5..1f74760 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
@@ -50,7 +50,7 @@ static unsigned int enable_msix = 1;
 
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
 MODULE_VERSION(BUILD_STR);
-MODULE_AUTHOR("Emulex Corporation");
+MODULE_AUTHOR("Avago Technologies");
 MODULE_LICENSE("GPL");
 module_param(be_iopoll_budget, int, 0);
 module_param(enable_msix, int, 0);
@@ -552,7 +552,7 @@ MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 
 static struct scsi_host_template beiscsi_sht = {
 	.module = THIS_MODULE,
-	.name = "Emulex 10Gbe open-iscsi Initiator Driver",
+	.name = "Avago Technologies 10Gbe open-iscsi Initiator Driver",
 	.proc_name = DRV_NAME,
 	.queuecommand = iscsi_queuecommand,
 	.change_queue_depth = scsi_change_queue_depth,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 7ee0ffc..e70ea26b 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
@@ -37,7 +37,7 @@
 
 #define DRV_NAME		"be2iscsi"
 #define BUILD_STR		"10.4.114.0"
-#define BE_NAME			"Emulex OneConnect" \
+#define BE_NAME			"Avago Technologies OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
 
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 681d4e8..c2c4d69 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index bd81446..9356b9a 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -1,5 +1,5 @@
 /**
- * Copyright (C) 2005 - 2014 Emulex
+ * Copyright (C) 2005 - 2015 Avago Technologies
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -7,12 +7,12 @@
  * as published by the Free Software Foundation.  The full GNU General
  * Public License is included in this distribution in the file called COPYING.
  *
- * Written by: Jayamohan Kallickal (jayamohan.kallickal@emulex.com)
+ * Written by: Jayamohan Kallickal (jayamohan.kallickal@avagotech.com)
  *
  * Contact Information:
- * linux-drivers@emulex.com
+ * linux-drivers@avagotech.com
  *
- * Emulex
+ * Avago Technologies
  * 3333 Susan Street
  * Costa Mesa, CA 92626
  */
-- 
1.8.3.1

