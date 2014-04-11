From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 19/42] qla2xxx: Change copyright year to 2014 in all the source files.
Date: Fri, 11 Apr 2014 16:54:24 -0400
Message-ID: <1397249687-32666-20-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:54858 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbaDKVcv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:51 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
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
 drivers/scsi/qla2xxx/qla_mr.c       |    2 +-
 drivers/scsi/qla2xxx/qla_mr.h       |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c       |    2 +-
 drivers/scsi/qla2xxx/qla_nx.h       |    2 +-
 drivers/scsi/qla2xxx/qla_nx2.c      |    2 +-
 drivers/scsi/qla2xxx/qla_nx2.h      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c       |    2 +-
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |    2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c     |    2 +-
 drivers/scsi/qla2xxx/qla_tmpl.h     |    2 +-
 drivers/scsi/qla2xxx/qla_version.h  |    2 +-
 29 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/Documentation/scsi/LICENSE.qla2xxx b/Documentation/scsi/LICENSE.qla2xxx
index 5020b7b..52f0b43 100644
--- a/Documentation/scsi/LICENSE.qla2xxx
+++ b/Documentation/scsi/LICENSE.qla2xxx
@@ -1,4 +1,4 @@
-Copyright (c) 2003-2013 QLogic Corporation
+Copyright (c) 2003-2014 QLogic Corporation
 QLogic Linux FC-FCoE Driver
 
 This program includes a device driver for Linux 3.x.
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index bc0cee3..900411a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 467c694..524f9eb 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 4e49d0a..d38f9ef 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b063c39..08572b9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index feae593..e1fc4e6 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index dd9b7fe0..a81e8ba 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 32ab809..2ca39b8 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 3a7353e..a9f86e7 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b66710b..a96efff 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e377f9d2..a0df3b1 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ec6c8f5..3260ec5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index ce8b5fb..be5b204 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e607568..8707a64 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7549d09..014f8c3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0f7887d..a2e3787 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f0a8522..8999824 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index c1df39a..1801e5f 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index e529dfa..1e6941e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 61774bc..c268b3f 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index d978a5d..59c4778 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 131a9d5..e38d84c 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_nx2.h b/drivers/scsi/qla2xxx/qla_nx2.h
index 52342cf..c9ff2cb 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.h
+++ b/drivers/scsi/qla2xxx/qla_nx2.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ed44e63..b182d276 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index 46ef0ac..2fb7ebf 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index f28123e..5dcaaca 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index f7d04d4..872ec7e 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index c9d2fff..ce1593c 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index e36b947..cdd2fc6 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -1,6 +1,6 @@
 /*
  * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2013 QLogic Corporation
+ * Copyright (c)  2003-2014 QLogic Corporation
  *
  * See LICENSE.qla2xxx for copyright and licensing details.
  */
-- 
1.7.7

