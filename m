From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 11/12] qla4xxx: Updated the Copyright header
Date: Thu, 2 Dec 2010 22:12:51 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F4122@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3267 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0LCGMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:55 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_dbg.c     |    2 +-
 drivers/scsi/qla4xxx/ql4_dbg.h     |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h     |    2 +-
 drivers/scsi/qla4xxx/ql4_fw.h      |    2 +-
 drivers/scsi/qla4xxx/ql4_glbl.h    |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_inline.h  |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c     |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c     |    2 +-
 drivers/scsi/qla4xxx/ql4_nvram.c   |    2 +-
 drivers/scsi/qla4xxx/ql4_nvram.h   |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c      |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.h      |    6 +++---
 drivers/scsi/qla4xxx/ql4_os.c      |    2 +-
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 16 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index edcf048..af62c3c 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_dbg.h b/drivers/scsi/qla4xxx/ql4_dbg.h
index d861c3b..abd8360 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.h
+++ b/drivers/scsi/qla4xxx/ql4_dbg.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 060e64f..2fc0045 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 5e757d7..c198579 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 6575a47..8fad99b 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index dc01fa3..1629c48 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_inline.h b/drivers/scsi/qla4xxx/ql4_inline.h
index 9471ac7..62f90bd 100644
--- a/drivers/scsi/qla4xxx/ql4_inline.h
+++ b/drivers/scsi/qla4xxx/ql4_inline.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 5ae49fd..75fcd82 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 90a217f..6ffbe97 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index b7e43b1..f65626a 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index f0d0fbf..b4b859b 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.h b/drivers/scsi/qla4xxx/ql4_nvram.h
index 7a8fc66..b3831bd 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.h
+++ b/drivers/scsi/qla4xxx/ql4_nvram.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 18b0ad6..3d5ef2d 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2009 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index ff689bf..35376a1 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -1,8 +1,8 @@
 /*
- * QLogic Fibre Channel HBA Driver
- * Copyright (c)  2003-2008 QLogic Corporation
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
- * See LICENSE.qla2xxx for copyright and licensing details.
+ * See LICENSE.qla4xxx for copyright and licensing details.
  */
 #ifndef __QLA_NX_H
 #define __QLA_NX_H
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3cb74c9..3fc1d25 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index 9bfacf4..454d3f5 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -1,6 +1,6 @@
 /*
  * QLogic iSCSI HBA Driver
- * Copyright (c)  2003-2006 QLogic Corporation
+ * Copyright (c)  2003-2010 QLogic Corporation
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
-- 
1.7.3.2

