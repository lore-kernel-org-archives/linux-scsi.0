From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 14/42] qla2xxx: Update the driver license.
Date: Wed, 22 Aug 2012 14:21:08 -0400
Message-ID: <1345659696-3670-15-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:59772 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964848Ab2HVSiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:15 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Update the driver license from 2003-2011 to 2003-2012.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 Documentation/scsi/LICENSE.qla2xxx  |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c     |    2 +-
 drivers/scsi/qla2xxx/qla_bsg.c      |    2 +-
 drivers/scsi/qla2xxx/qla_bsg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c      |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_def.h      |    2 +-
 drivers/scsi/qla2xxx/qla_dfs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h       |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c       |    2 +-
 drivers/scsi/qla2xxx/qla_init.c     |    2 +-
 drivers/scsi/qla2xxx/qla_inline.h   |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c      |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_mid.c      |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c       |    2 +-
 drivers/scsi/qla2xxx/qla_nx.h       |    2 +-
 drivers/scsi/qla2xxx/qla_os.c       |    2 +-
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |    2 +-
 drivers/scsi/qla2xxx/qla_version.h  |    2 +-
 23 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/scsi/LICENSE.qla2xxx b/Documentation/scsi/LICENSE.qla2xxx
index ce0fdf3..27a91cf 100644
--- a/Documentation/scsi/LICENSE.qla2xxx
+++ b/Documentation/scsi/LICENSE.qla2xxx
@@ -1,4 +1,4 @@
-Copyright (c) 2003-2011 QLogic Corporation
+Copyright (c) 2003-2012 QLogic Corporation
 QLogic Linux FC-FCoE Driver
 
 This program includes a device driver for Linux 3.x.
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d8858df..2cc8e12 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 581592f..d25f0fa 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index cd63ec7..37b8b7b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 647ddfa..6de4d03 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index f278df8..8f911c0 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index faaea58..9feb54c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 499c74e..706c4f7 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 84543fe..59524aa 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8d77e52..5afd72e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 05260d2..ddd2a9d 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9ea0bcb..96fc04f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index c12add2..c0462c0 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 74c69ba..f58b2b2 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f6415fe..e6a01e4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1b7bea1..3d35024 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 54330ff..4c2da06 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 9f4dcf5..3653c8f 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index d0aa16c..6c953e8 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c2eb6fa..22db1f6e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index d70f030..892a81e 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index e66fa7f..41ed7af 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index f5fdb16..e6a5270 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2012 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
-- 
1.7.7

