From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 4/5] bnx2fc: Update copyright information
Date: Fri, 8 Mar 2013 13:28:53 -0800
Message-ID: <1362778134-21045-5-git-send-email-bprakash@broadcom.com>
References: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1916 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3CHV2u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Mar 2013 16:28:50 -0500
In-Reply-To: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c  |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 2f118e3..676dba3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -2,7 +2,7 @@
 #define _BNX2FC_H_
 /* bnx2fc.h: Broadcom NetXtreme II Linux FCoE offload driver.
  *
- * Copyright (c) 2008 - 2011 Broadcom Corporation
+ * Copyright (c) 2008 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index bdbbb13..b1c9a4f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -3,7 +3,7 @@
  * This file contains helper routines that handle ELS requests
  * and responses.
  *
- * Copyright (c) 2008 - 2011 Broadcom Corporation
+ * Copyright (c) 2008 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index dd2c5c9..1e852d6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -3,7 +3,7 @@
  * cnic modules to create FCoE instances, send/receive non-offloaded
  * FIP/FCoE packets, listen to link events etc.
  *
- * Copyright (c) 2008 - 2011 Broadcom Corporation
+ * Copyright (c) 2008 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index c1fa69e..b3ee916 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -2,7 +2,7 @@
  * This file contains the code that low level functions that interact
  * with 57712 FCoE firmware.
  *
- * Copyright (c) 2008 - 2011 Broadcom Corporation
+ * Copyright (c) 2008 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 539b95b..9701d6f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1,7 +1,7 @@
 /* bnx2fc_io.c: Broadcom NetXtreme II Linux FCoE offload driver.
  * IO manager and SCSI IO processing.
  *
- * Copyright (c) 2008 - 2011 Broadcom Corporation
+ * Copyright (c) 2008 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index c57a3bb..4d93177 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -2,7 +2,7 @@
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
- * Copyright (c) 2008 - 2011 Broadcom Corporation
+ * Copyright (c) 2008 - 2013 Broadcom Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.1


