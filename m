From: madhu.iyengar@qlogic.com
Subject: [PATCH 08/18] qla2xxx: Update copyright banner.
Date: Wed, 30 Mar 2011 11:46:23 -0700
Message-ID: <1301510793-2492-9-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45795 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S932105Ab1C3SvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:16 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
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
index d3e58d7..cee3eed 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 903b058..8c10e2c 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 074a999..0f0f54e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 0961411..c53719a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index b74e6b5..9304145 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6c51c0a..316f01b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 6271353..a5a4e12 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 631fefc..11490be 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d48326e..d009c6f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 74a91b6..8cd9066 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0f75fab..2c9f47a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 48f97a9..4d17e70 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d78d589..7bac3cd 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5bb4d58..85dd791 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index db2e4b1..33502e8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 2b69392..3082e2f 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 76ec876..b221705 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index ed5883f..8a21832 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6c002fb..aab3e20 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index f0b2b99..d70f030 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 2207062..6936476 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 3a260c3..86f589c 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2010 QLogic Corporation
+ * Copyright (c)  2003-2011 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
-- 
1.6.0.2

