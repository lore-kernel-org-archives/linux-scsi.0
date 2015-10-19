From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 1/7] bnx2fc: Update copyright for 2015.
Date: Mon, 19 Oct 2015 15:40:35 -0400
Message-ID: <1445283641-7358-2-git-send-email-chad.dupuis@qlogic.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:43391 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbbJSUTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:19:15 -0400
In-Reply-To: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc.h           |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_constants.h |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_debug.c     |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_els.c       |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_io.c        |    4 ++--
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       |    4 ++--
 10 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
index fe2106c..66deff1 100644
--- a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
+++ b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
@@ -2,8 +2,8 @@
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 1346e05..4791b29 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -1,7 +1,7 @@
 /* bnx2fc.h: QLogic NetXtreme II Linux FCoE offload driver.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_constants.h b/drivers/scsi/bnx2fc/bnx2fc_constants.h
index e147cc7..52e8297 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_constants.h
+++ b/drivers/scsi/bnx2fc/bnx2fc_constants.h
@@ -2,8 +2,8 @@
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.c b/drivers/scsi/bnx2fc/bnx2fc_debug.c
index d055df0..e3a7ca4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_debug.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.c
@@ -2,8 +2,8 @@
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.h b/drivers/scsi/bnx2fc/bnx2fc_debug.h
index 2b90067..737398f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_debug.h
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.h
@@ -2,8 +2,8 @@
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index ef355c1..d8b1651 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -3,8 +3,8 @@
  * This file contains helper routines that handle ELS requests
  * and responses.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 231d056..4098c35 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -3,8 +3,8 @@
  * cnic modules to create FCoE instances, send/receive non-offloaded
  * FIP/FCoE packets, listen to link events etc.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index c6688d7..3ef3d72 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -2,8 +2,8 @@
  * This file contains the code that low level functions that interact
  * with 57712 FCoE firmware.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 9ecca85..890baee 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1,8 +1,8 @@
 /* bnx2fc_io.c: QLogic NetXtreme II Linux FCoE offload driver.
  * IO manager and SCSI IO processing.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index c66c708..8bcd229 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -2,8 +2,8 @@
  * Handles operations such as session offload/upload etc, and manages
  * session resources such as connection id and qp resources.
  *
- * Copyright (c) 2008 - 2013 Broadcom Corporation
- * Copyright (c) 2014, QLogic Corporation
+ * Copyright (c) 2008-2013 Broadcom Corporation
+ * Copyright (c) 2014-2015 QLogic Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.7

