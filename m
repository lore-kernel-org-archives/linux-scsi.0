From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/4] qla4xxx: Update Copyright header
Date: Fri, 16 Aug 2013 07:03:04 -0400
Message-ID: <1376650985-11416-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41529 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547Ab3HPMAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Aug 2013 08:00:50 -0400
In-Reply-To: <1376650985-11416-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 Documentation/scsi/LICENSE.qla4xxx | 2 +-
 drivers/scsi/qla4xxx/ql4_83xx.c    | 2 +-
 drivers/scsi/qla4xxx/ql4_83xx.h    | 2 +-
 drivers/scsi/qla4xxx/ql4_attr.c    | 2 +-
 drivers/scsi/qla4xxx/ql4_bsg.c     | 2 +-
 drivers/scsi/qla4xxx/ql4_def.h     | 2 +-
 drivers/scsi/qla4xxx/ql4_fw.h      | 2 +-
 drivers/scsi/qla4xxx/ql4_glbl.h    | 2 +-
 drivers/scsi/qla4xxx/ql4_init.c    | 2 +-
 drivers/scsi/qla4xxx/ql4_inline.h  | 2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c    | 2 +-
 drivers/scsi/qla4xxx/ql4_isr.c     | 2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c     | 2 +-
 drivers/scsi/qla4xxx/ql4_nvram.c   | 2 +-
 drivers/scsi/qla4xxx/ql4_nvram.h   | 2 +-
 drivers/scsi/qla4xxx/ql4_nx.c      | 2 +-
 drivers/scsi/qla4xxx/ql4_nx.h      | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c      | 2 +-
 drivers/scsi/qla4xxx/ql4_version.h | 2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/scsi/LICENSE.qla4xxx b/Documentation/scsi/LICENSE.qla4xxx
index 78c169f..fcc27ad 100644
--- a/Documentation/scsi/LICENSE.qla4xxx
+++ b/Documentation/scsi/LICENSE.qla4xxx
@@ -1,4 +1,4 @@
-Copyright (c) 2003-2012 QLogic Corporation
+Copyright (c) 2003-2013 QLogic Corporation
 QLogic Linux iSCSI Driver
 
 This program includes a device driver for Linux 3.x.
diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index d5335b7..9be4f8f 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)   2003-2012 QLogic Corporation
+ * Copyright (c)   2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_83xx.h b/drivers/scsi/qla4xxx/ql4_83xx.h
index fab237f..1b8c544 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.h
+++ b/drivers/scsi/qla4xxx/ql4_83xx.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index b015ee4..463239c 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2011 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index 8acdc58..cf8fdf1 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c) 2011 QLogic Corporation
+ * Copyright (c) 2011-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index cf0f30c..77d48c7 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 7aa1323..51d1a70 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index f9963de..cec80b6 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 222b91a..7456eeb 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_inline.h b/drivers/scsi/qla4xxx/ql4_inline.h
index 6f4decd..8503ad6 100644
--- a/drivers/scsi/qla4xxx/ql4_inline.h
+++ b/drivers/scsi/qla4xxx/ql4_inline.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index fad71ed..e5697ab 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 4fefa34..7dff09f 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index fa1a06a..62d4208 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index 325db1f..3bf418f 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.h b/drivers/scsi/qla4xxx/ql4_nvram.h
index dba0514..e97d79f 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.h
+++ b/drivers/scsi/qla4xxx/ql4_nvram.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 378282b..67831aa 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 9dc0bbf..14500a0 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6956de9d..f8a0a26 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index c085c9a..28e8306 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2012 QLogic Corporation
+ * Copyright (c)  2003-2013 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
-- 
1.8.2.GIT

