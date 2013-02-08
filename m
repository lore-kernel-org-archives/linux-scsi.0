From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 13/23] qla2xxx: Update the copyright information.
Date: Fri,  8 Feb 2013 01:57:54 -0500
Message-ID: <1360306684-8286-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:1260 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759987Ab3BHHTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:11 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c     |    2 +-
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
 21 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 83d7984..7256167 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 37b8b7b..e9f6b9b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 29101fe..4e58001 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 8f911c0..35e20b4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e96abfc..5c1a865 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 706c4f7..792a292 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index da1a8da..1ac2b0e 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ee8ea95..b67f74a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 01efc0e..40c5933 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7568324..8888d9b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 130f6f3..68e2c4a 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6055d96..d263031 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9380d96..fa738cd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 550f75a..2b6782d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 95cb6e78..f868a9f 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index dc4be5b..10754f51 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 5502732..d268e84 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a947f70..c484e21 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index 892a81e..46ef0ac 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index f5a1a56..3bef673 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 49697ca..2b6e478 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
-- 
1.7.7

