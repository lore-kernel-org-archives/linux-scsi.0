From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 3/7] bnx2fc: Update copyright for 2017.
Date: Mon, 26 Jun 2017 08:59:34 -0700
Message-ID: <20170626155938.2091-4-chad.dupuis@cavium.com>
References: <20170626155938.2091-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0086.outbound.protection.outlook.com ([104.47.37.86]:48186
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751653AbdFZP7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 11:59:49 -0400
In-Reply-To: <20170626155938.2091-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc.h           | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_constants.h | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_debug.c     | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_debug.h     | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_els.c       | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c        | 3 ++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       | 3 ++-
 10 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
index ac1c0b6..e4469df9 100644
--- a/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
+++ b/drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h
@@ -3,7 +3,8 @@
  * session resources such as connection id and qp resources.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 1f424e4..c192840 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -1,7 +1,8 @@
 /* bnx2fc.h: QLogic Linux FCoE offload driver.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_constants.h b/drivers/scsi/bnx2fc/bnx2fc_constants.h
index 5b20efb..9ed1503 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_constants.h
+++ b/drivers/scsi/bnx2fc/bnx2fc_constants.h
@@ -3,7 +3,8 @@
  * session resources such as connection id and qp resources.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.c b/drivers/scsi/bnx2fc/bnx2fc_debug.c
index c9e0bc7..47ba3ba 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_debug.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.c
@@ -3,7 +3,8 @@
  * session resources such as connection id and qp resources.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_debug.h b/drivers/scsi/bnx2fc/bnx2fc_debug.h
index 34fda3e..76717ac 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_debug.h
+++ b/drivers/scsi/bnx2fc/bnx2fc_debug.h
@@ -3,7 +3,8 @@
  * session resources such as connection id and qp resources.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index fee12c3..76e65a3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -4,7 +4,8 @@
  * and responses.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 2025510..d9f9c56 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -4,7 +4,8 @@
  * FIP/FCoE packets, listen to link events etc.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 5ff9f89..913c750 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -3,7 +3,8 @@
  * with 57712 FCoE firmware.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 898461b..6e8b9be 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -2,7 +2,8 @@
  * IO manager and SCSI IO processing.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 739bfb6..59a2dfb 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -3,7 +3,8 @@
  * session resources such as connection id and qp resources.
  *
  * Copyright (c) 2008-2013 Broadcom Corporation
- * Copyright (c) 2014-2015 QLogic Corporation
+ * Copyright (c) 2014-2016 QLogic Corporation
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.8.5.6
