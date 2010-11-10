From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 15/16] BNX2I: Updated copyright and maintainer info
Date: Wed, 10 Nov 2010 15:04:56 -0800
Message-ID: <1289430297-30221-16-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2898 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab0KJXDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:10 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/57xx_iscsi_constants.h |    3 ++-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |    3 ++-
 drivers/scsi/bnx2i/bnx2i.h                |    3 ++-
 drivers/scsi/bnx2i/bnx2i_hwi.c            |    3 ++-
 drivers/scsi/bnx2i/bnx2i_init.c           |    3 ++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |    3 ++-
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |    3 ++-
 7 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2i/57xx_iscsi_constants.h b/drivers/scsi/bnx2i/57xx_iscsi_constants.h
index 1b6f86b..30e6bdb 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_constants.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_constants.h
@@ -1,12 +1,13 @@
 /* 57xx_iscsi_constants.h: Broadcom NetXtreme II iSCSI HSI
  *
- * Copyright (c) 2006 - 2009 Broadcom Corporation
+ * Copyright (c) 2006 - 2010 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
+ * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  */
 #ifndef __57XX_ISCSI_CONSTANTS_H_
 #define __57XX_ISCSI_CONSTANTS_H_
diff --git a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
index 36af1af..dad6c8a 100644
--- a/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
+++ b/drivers/scsi/bnx2i/57xx_iscsi_hsi.h
@@ -1,12 +1,13 @@
 /* 57xx_iscsi_hsi.h: Broadcom NetXtreme II iSCSI HSI.
  *
- * Copyright (c) 2006 - 2009 Broadcom Corporation
+ * Copyright (c) 2006 - 2010 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
+ * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  */
 #ifndef __57XX_ISCSI_HSI_LINUX_LE__
 #define __57XX_ISCSI_HSI_LINUX_LE__
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 72feb6c..f9719d4 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -1,6 +1,6 @@
 /* bnx2i.h: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2009 Broadcom Corporation
+ * Copyright (c) 2006 - 2010 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
@@ -9,6 +9,7 @@
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
+ * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  */
 
 #ifndef _BNX2I_H_
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index c577da6..b38d193 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1,6 +1,6 @@
 /* bnx2i_hwi.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2009 Broadcom Corporation
+ * Copyright (c) 2006 - 2010 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
@@ -9,6 +9,7 @@
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
+ * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  */
 
 #include <linux/gfp.h>
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 338caac..131ef80 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -1,6 +1,6 @@
 /* bnx2i.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2009 Broadcom Corporation
+ * Copyright (c) 2006 - 2010 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
@@ -9,6 +9,7 @@
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
+ * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  */
 
 #include "bnx2i.h"
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 99af8ca..b4856ad 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1,7 +1,7 @@
 /*
  * bnx2i_iscsi.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2006 - 2009 Broadcom Corporation
+ * Copyright (c) 2006 - 2010 Broadcom Corporation
  * Copyright (c) 2007, 2008 Red Hat, Inc.  All rights reserved.
  * Copyright (c) 2007, 2008 Mike Christie
  *
@@ -10,6 +10,7 @@
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
+ * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  */
 
 #include <linux/slab.h>
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index 96426b7..9174196 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -1,12 +1,13 @@
 /* bnx2i_sysfs.c: Broadcom NetXtreme II iSCSI driver.
  *
- * Copyright (c) 2004 - 2009 Broadcom Corporation
+ * Copyright (c) 2004 - 2010 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation.
  *
  * Written by: Anil Veerabhadrappa (anilgv@broadcom.com)
+ * Maintained by: Eddie Wai (eddie.wai@broadcom.com)
  */
 
 #include "bnx2i.h"
-- 
1.7.0.5


