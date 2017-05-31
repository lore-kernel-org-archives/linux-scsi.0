From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 02/15] qedf: Update copyright to 2017.
Date: Wed, 31 May 2017 06:33:49 -0700
Message-ID: <20170531133402.16629-3-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0080.outbound.protection.outlook.com ([104.47.36.80]:42129
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750904AbdEaNeR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:34:17 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/drv_fcoe_fw_funcs.c | 2 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h | 2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.c | 2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.h | 2 +-
 drivers/scsi/qedf/qedf.h              | 2 +-
 drivers/scsi/qedf/qedf_attr.c         | 2 +-
 drivers/scsi/qedf/qedf_dbg.h          | 2 +-
 drivers/scsi/qedf/qedf_debugfs.c      | 2 +-
 drivers/scsi/qedf/qedf_els.c          | 2 +-
 drivers/scsi/qedf/qedf_fip.c          | 2 +-
 drivers/scsi/qedf/qedf_hsi.h          | 2 +-
 drivers/scsi/qedf/qedf_io.c           | 2 +-
 drivers/scsi/qedf/qedf_main.c         | 2 +-
 drivers/scsi/qedf/qedf_version.h      | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qedf/drv_fcoe_fw_funcs.c b/drivers/scsi/qedf/drv_fcoe_fw_funcs.c
index 8c65e3b..7d91e53 100644
--- a/drivers/scsi/qedf/drv_fcoe_fw_funcs.c
+++ b/drivers/scsi/qedf/drv_fcoe_fw_funcs.c
@@ -1,5 +1,5 @@
 /* QLogic FCoE Offload Driver
- * Copyright (c) 2016 Cavium Inc.
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This software is available under the terms of the GNU General Public License
  * (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/drv_fcoe_fw_funcs.h b/drivers/scsi/qedf/drv_fcoe_fw_funcs.h
index 617529b..f9c50fa 100644
--- a/drivers/scsi/qedf/drv_fcoe_fw_funcs.h
+++ b/drivers/scsi/qedf/drv_fcoe_fw_funcs.h
@@ -1,5 +1,5 @@
 /* QLogic FCoE Offload Driver
- * Copyright (c) 2016 Cavium Inc.
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This software is available under the terms of the GNU General Public License
  * (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/drv_scsi_fw_funcs.c b/drivers/scsi/qedf/drv_scsi_fw_funcs.c
index 11e0cc0..5d5095e 100644
--- a/drivers/scsi/qedf/drv_scsi_fw_funcs.c
+++ b/drivers/scsi/qedf/drv_scsi_fw_funcs.c
@@ -1,5 +1,5 @@
 /* QLogic FCoE Offload Driver
- * Copyright (c) 2016 Cavium Inc.
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This software is available under the terms of the GNU General Public License
  * (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/drv_scsi_fw_funcs.h b/drivers/scsi/qedf/drv_scsi_fw_funcs.h
index 9cb4541..8fbe6e4 100644
--- a/drivers/scsi/qedf/drv_scsi_fw_funcs.h
+++ b/drivers/scsi/qedf/drv_scsi_fw_funcs.h
@@ -1,5 +1,5 @@
 /* QLogic FCoE Offload Driver
- * Copyright (c) 2016 Cavium Inc.
+ * Copyright (c) 2016-2017 Cavium Inc.
  *
  * This software is available under the terms of the GNU General Public License
  * (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 40aeb6b..a5b89b0 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index 4772061..1349f8a 100644
--- a/drivers/scsi/qedf/qedf_attr.c
+++ b/drivers/scsi/qedf/qedf_attr.c
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_dbg.h b/drivers/scsi/qedf/qedf_dbg.h
index 7d173f48..50083ca 100644
--- a/drivers/scsi/qedf/qedf_dbg.h
+++ b/drivers/scsi/qedf/qedf_dbg.h
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index 00a1d64..2b1ef30 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 QLogic Corporation
+ *  Copyright (c) 2016-2017 QLogic Corporation
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index c505d41..e197fd6 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index e10b91c..2dfb817 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_hsi.h b/drivers/scsi/qedf/qedf_hsi.h
index dfd65de..7faef80 100644
--- a/drivers/scsi/qedf/qedf_hsi.h
+++ b/drivers/scsi/qedf/qedf_hsi.h
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 1d7f90d..ca9097b 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 8d0a999..9457665 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_version.h
index 4ae5f53..d46c487 100644
--- a/drivers/scsi/qedf/qedf_version.h
+++ b/drivers/scsi/qedf/qedf_version.h
@@ -1,6 +1,6 @@
 /*
  *  QLogic FCoE Offload Driver
- *  Copyright (c) 2016 Cavium Inc.
+ *  Copyright (c) 2016-2017 Cavium Inc.
  *
  *  This software is available under the terms of the GNU General Public License
  *  (GPL) Version 2, available from the file COPYING in the main directory of
-- 
1.8.5.6
