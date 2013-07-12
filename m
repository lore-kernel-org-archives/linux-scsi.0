From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 1/2] BNX2I: Update version and copyright year 2013
Date: Thu, 11 Jul 2013 17:15:55 -0700
Message-ID: <1373588156-14077-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4931 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab3GLAQN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jul 2013 20:16:13 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Old version: 2.7.2.2
New version: 2.7.6.2

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/57xx_iscsi_constants.h |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |    2 +-
 drivers/scsi/bnx2i/bnx2i.h                |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c            |    2 +-
 drivers/scsi/bnx2i/bnx2i_init.c           |    6 +++---
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |    2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |    2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bnx2i/57xx_iscsi_constants.h b/drivers/scsi/bnx2i/57xx_iscsi_constants.h
index 25093a0..3d33767 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_constants.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_constants.h
@@ -1,6 +1,6 @@
 /* 57xx_iscsi_constants.h: Broadcom NetXtreme II iSCSI HSI
  *
- * Copyright (c) 2006 - 2012 Broadcom Corporation
+ * Copyright (c) 2006 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
index f2db5fe..37049e4 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
@@ -1,6 +1,6 @@
 /* 57xx_iscsi_hsi.h: Broadcom NetXtreme II iSCSI HSI.
  *
- * Copyright (c) 2006 - 2012 Broadcom Corporation
+ * Copyright (c) 2006 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index f109e3b..6940f09 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -1,6 +1,6 @@
 /* bnx2i.h: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2012 Broadcom Corporation
+ * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index a28b03e..af3e675 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1,6 +1,6 @@
 /* bnx2i_hwi.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2012 Broadcom Corporation
+ * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 50fef69..b6f6f43 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -1,6 +1,6 @@
 /* bnx2i.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2012 Broadcom Corporation
+ * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
@@ -18,8 +18,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.7.2.2"
-#define DRV_MODULE_RELDATE	"Apr 25, 2012"
+#define DRV_MODULE_VERSION	"2.7.6.2"
+#define DRV_MODULE_RELDATE	"Jun 06, 2013"
 
 static char version[] =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 0056e47..fabeb88 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1,7 +1,7 @@
 /*
  * bnx2i_iscsi.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2012 Broadcom Corporation
+ * Copyright (c) 2006 - 2013 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index c61cf7a..a0a3d9f 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -1,6 +1,6 @@
 /* bnx2i_sysfs.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2004 - 2012 Broadcom Corporation
+ * Copyright (c) 2004 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.7.4


