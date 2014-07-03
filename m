From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/3] bnx2i: Rebranding bnx2i driver
Date: Thu, 3 Jul 2014 08:18:27 -0400
Message-ID: <1404389909-15319-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1404389909-15319-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:46946 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbaGCMwz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 08:52:55 -0400
In-Reply-To: <1404389909-15319-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

QLogic has acquired the NetXtremeII products and drivers from Broadcom.
This patch re-brands bnx2i driver as a QLogic driver

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Acked-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/57xx_iscsi_constants.h |  6 ++++--
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |  6 ++++--
 drivers/scsi/bnx2i/Kconfig                |  4 ++--
 drivers/scsi/bnx2i/bnx2i.h                |  6 ++++--
 drivers/scsi/bnx2i/bnx2i_hwi.c            |  6 ++++--
 drivers/scsi/bnx2i/bnx2i_init.c           | 10 ++++++----
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |  8 +++++---
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |  6 ++++--
 8 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/bnx2i/57xx_iscsi_constants.h b/drivers/scsi/bnx2i/57xx_iscsi_constants.h
index 3d33767..9175341 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_constants.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_constants.h
@@ -1,13 +1,15 @@
-/* 57xx_iscsi_constants.h: Broadcom NetXtreme II iSCSI HSI
+/* 57xx_iscsi_constants.h: QLogic NetXtreme II iSCSI HSI
  *
  * Copyright (c) 2006 - 2013 Broadcom Corporation
+ * Copyright (c) 2014, QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
- * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
 #ifndef __57XX_ISCSI_CONSTANTS_H_
 #define __57XX_ISCSI_CONSTANTS_H_
diff --git a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
index 7052a83..19b3a97 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
@@ -1,13 +1,15 @@
-/* 57xx_iscsi_hsi.h: Broadcom NetXtreme II iSCSI HSI.
+/* 57xx_iscsi_hsi.h: QLogic NetXtreme II iSCSI HSI.
  *
  * Copyright (c) 2006 - 2013 Broadcom Corporation
+ * Copyright (c) 2014, QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
- * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
 #ifndef __57XX_ISCSI_HSI_LINUX_LE__
 #define __57XX_ISCSI_HSI_LINUX_LE__
diff --git a/drivers/scsi/bnx2i/Kconfig b/drivers/scsi/bnx2i/Kconfig
index 01cff18..44ce54e 100644
--- a/drivers/scsi/bnx2i/Kconfig
+++ b/drivers/scsi/bnx2i/Kconfig
@@ -1,5 +1,5 @@
 config SCSI_BNX2_ISCSI
-	tristate "Broadcom NetXtreme II iSCSI support"
+	tristate "QLogic NetXtreme II iSCSI support"
 	depends on NET
 	depends on PCI
 	select SCSI_ISCSI_ATTRS
@@ -8,5 +8,5 @@ config SCSI_BNX2_ISCSI
 	select NET_VENDOR_BROADCOM
 	select CNIC
 	---help---
-	This driver supports iSCSI offload for the Broadcom NetXtreme II
+	This driver supports iSCSI offload for the QLogic NetXtreme II
 	devices.
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index c73bbcb..ed7f322 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -1,15 +1,17 @@
-/* bnx2i.h: Broadcom NetXtreme II iSCSI driver.
+/* bnx2i.h: QLogic NetXtreme II iSCSI driver.
  *
  * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
+ * Copyright (c) 2014, QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
- * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
 
 #ifndef _BNX2I_H_
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index b5ffd28..cfb8e90 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1,15 +1,17 @@
-/* bnx2i_hwi.c: Broadcom NetXtreme II iSCSI driver.
+/* bnx2i_hwi.c: QLogic NetXtreme II iSCSI driver.
  *
  * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
+ * Copyright (c) 2014, QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
- * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
 
 #include <linux/gfp.h>
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 80c03b4..748ff8e 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -1,15 +1,17 @@
-/* bnx2i.c: Broadcom NetXtreme II iSCSI driver.
+/* bnx2i.c: QLogic NetXtreme II iSCSI driver.
  *
  * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
+ * Copyright (c) 2014, QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
- * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
 
 #include "bnx2i.h"
@@ -22,14 +24,14 @@ static u32 adapter_count;
 #define DRV_MODULE_RELDATE	"Jun 06, 2013"
 
 static char version[] =
-		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
+		"QLogic NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
 		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
 
 MODULE_AUTHOR("Anil Veerabhadrappa <anilgv@broadcom.com> and "
 	      "Eddie Wai <eddie.wai@broadcom.com>");
 
-MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708/5709/57710/57711/57712"
+MODULE_DESCRIPTION("QLogic NetXtreme II BCM5706/5708/5709/57710/57711/57712"
 		   "/57800/57810/57840 iSCSI Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index cabc8c1..3bbf982 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1,16 +1,18 @@
 /*
- * bnx2i_iscsi.c: Broadcom NetXtreme II iSCSI driver.
+ * bnx2i_iscsi.c: QLogic NetXtreme II iSCSI driver.
  *
  * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
+ * Copyright (c) 2014, QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
- * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
 
 #include <linux/slab.h>
@@ -2252,7 +2254,7 @@ static umode_t bnx2i_attr_is_visible(int param_type, int param)
  */
 static struct scsi_host_template bnx2i_host_template = {
 	.module			= THIS_MODULE,
-	.name			= "Broadcom Offload iSCSI Initiator",
+	.name			= "QLogic Offload iSCSI Initiator",
 	.proc_name		= "bnx2i",
 	.queuecommand		= iscsi_queuecommand,
 	.eh_abort_handler	= iscsi_eh_abort,
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index a0a3d9f..6d56fd6 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -1,13 +1,15 @@
-/* bnx2i_sysfs.c: Broadcom NetXtreme II iSCSI driver.
+/* bnx2i_sysfs.c: QLogic NetXtreme II iSCSI driver.
  *
  * Copyright (c) 2004 - 2013 Broadcom Corporation
+ * Copyright (c) 2014, QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
- * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Previously Maintained by: Eddie Wai (eddie.wai@broadcom.com)
+ * Maintained by: QLogic-Storage-Upstream@qlogic.com
  */
 
 #include "bnx2i.h"
-- 
1.8.2.GIT

