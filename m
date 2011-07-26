From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND 11/11] bnx2fc: Update copyright and bump version
 to 1.0.4
Date: Tue, 26 Jul 2011 14:51:49 -0700
Message-ID: <1311717109-14077-12-git-send-email-bprakash@broadcom.com>
References: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2773 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab1GZVwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 17:52:07 -0400
In-Reply-To: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_els.c  |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b1b0b3e..42228ca 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -2,7 +2,7 @@
 #define _BNX2FC_H_
 /* bnx2fc.h: Broadcom NetXtreme II Linux FCoE offload driver.
  *
- * Copyright (c) 2008 - 2010 Broadcom Corporation
+ * Copyright (c) 2008 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -62,7 +62,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"1.0.3"
+#define BNX2FC_VERSION		"1.0.4"
 
 #define PFX			"bnx2fc: "
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index 2795ede..6e68096 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -3,7 +3,7 @@
  * This file contains helper routines that handle ELS requests
  * and responses.
  *
- * Copyright (c) 2008 - 2010 Broadcom Corporation
+ * Copyright (c) 2008 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 78e136f..833e912 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -3,7 +3,7 @@
  * cnic modules to create FCoE instances, send/receive non-offloaded
  * FIP/FCoE packets, listen to link events etc.
  *
- * Copyright (c) 2008 - 2010 Broadcom Corporation
+ * Copyright (c) 2008 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -22,7 +22,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 #define DRV_MODULE_NAME		"bnx2fc"
 #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Jun 10, 2011"
+#define DRV_MODULE_RELDATE	"Jun 23, 2011"
 
 
 static char version[] __devinitdata =
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index ec89359..72cfb14 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -2,7 +2,7 @@
  * This file contains the code that low level functions that interact
  * with 57712 FCoE firmware.
  *
- * Copyright (c) 2008 - 2010 Broadcom Corporation
+ * Copyright (c) 2008 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 7154c44..6cc3789 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1,7 +1,7 @@
 /* bnx2fc_io.c: Broadcom NetXtreme II Linux FCoE offload driver.
  * IO manager and SCSI IO processing.
  *
- * Copyright (c) 2008 - 2010 Broadcom Corporation
+ * Copyright (c) 2008 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 7eff269..d5311b5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -2,7 +2,7 @@
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
- * Copyright (c) 2008 - 2010 Broadcom Corporation
+ * Copyright (c) 2008 - 2011 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.0.6


