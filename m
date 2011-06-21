From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 4/4] BNX2I: Updated copyright and bump version
Date: Tue, 21 Jun 2011 09:49:54 -0700
Message-ID: <1308674994-4694-5-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3356 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1FUQuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2011 12:50:11 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Bumped version from 2.6.2.3 to 2.7.0.3

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
index 30e6bdb..aca593d 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_constants.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_constants.h
@@ -1,6 +1,6 @@
 /* 57xx_iscsi_constants.h: Broadcom NetXtreme II iSCSI HSI
  *
- * Copyright (c) 2006 - 2010 Broadcom Corporation
+ * Copyright (c) 2006 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
index dad6c8a..1c39177 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
@@ -1,6 +1,6 @@
 /* 57xx_iscsi_hsi.h: Broadcom NetXtreme II iSCSI HSI.
  *
- * Copyright (c) 2006 - 2010 Broadcom Corporation
+ * Copyright (c) 2006 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 4e5c002..bb21450 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -1,6 +1,6 @@
 /* bnx2i.h: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2010 Broadcom Corporation
+ * Copyright (c) 2006 - 2011 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index d5f3bf6..a031704 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1,6 +1,6 @@
 /* bnx2i_hwi.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2010 Broadcom Corporation
+ * Copyright (c) 2006 - 2011 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 28bfa9e..4f252a9 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -1,6 +1,6 @@
 /* bnx2i.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2010 Broadcom Corporation
+ * Copyright (c) 2006 - 2011 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
@@ -18,8 +18,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.6.2.3"
-#define DRV_MODULE_RELDATE	"Dec 31, 2010"
+#define DRV_MODULE_VERSION	"2.7.0.3"
+#define DRV_MODULE_RELDATE	"Jun 15, 2011"
 
 static char version[] __devinitdata =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index c095c32..f92ec95 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1,7 +1,7 @@
 /*
  * bnx2i_iscsi.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2010 Broadcom Corporation
+ * Copyright (c) 2006 - 2011 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index 9174196..83a77f7 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -1,6 +1,6 @@
 /* bnx2i_sysfs.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2004 - 2010 Broadcom Corporation
+ * Copyright (c) 2004 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.0.5


