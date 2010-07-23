From: giridhar.malavali@qlogic.com
Subject: [PATCH 15/17] qla2xxx: Update copyright banner.
Date: Fri, 23 Jul 2010 15:28:36 +0500
Message-ID: <1279880918-62876-16-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47969 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755708Ab0GWJ7z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:55 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
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
 22 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 93a4c20..d9b431d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 6b863f7..9067629 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 1f096da..cc7c52f 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2afc8a3..0961411 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 916c81f..6cfc28a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 84e9c6b..3a432ea 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 3a9a6ca..6271353 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 93f8339..631fefc 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 4688ad2..b7d940f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 2fabae8..4c08392 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9b58a79..1b7d80b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 84c2fea..48f97a9 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e27d947..c9c709e 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5180033..6982ba7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 02a4d35..6009b0c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index d1618b4..642cd79 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 4299df2..915b77a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 420e077..569232b 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 86d352a..50f6854 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index 2801c26..f0b2b99 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index df288dc..76de957 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 9b49b08..e75ccb9 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
-- 
1.6.0.2

