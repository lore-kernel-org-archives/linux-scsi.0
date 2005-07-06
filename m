From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 15/17] qla2xxx: Update copyright banner.
Date: Wed,  6 Jul 2005 10:32:27 -0700 (PDT)
Message-ID: <20050706173227.10568.96109.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:64598 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262438AbVGFRc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:32:28 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Update copyright banner.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/ql2100.c       |    2 +-
 drivers/scsi/qla2xxx/ql2200.c       |    2 +-
 drivers/scsi/qla2xxx/ql2300.c       |    2 +-
 drivers/scsi/qla2xxx/ql2322.c       |    2 +-
 drivers/scsi/qla2xxx/ql6312.c       |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c      |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_def.h      |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h       |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c       |    2 +-
 drivers/scsi/qla2xxx/qla_init.c     |    2 +-
 drivers/scsi/qla2xxx/qla_inline.h   |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c      |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c       |    2 +-
 drivers/scsi/qla2xxx/qla_rscn.c     |    2 +-
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |    2 +-
 drivers/scsi/qla2xxx/qla_version.h  |    2 +-
 21 files changed, 21 insertions(+), 21 deletions(-)

e18ad1fc29d37527f1a6425f7b7122957c4ed5d7
diff --git a/drivers/scsi/qla2xxx/ql2100.c b/drivers/scsi/qla2xxx/ql2100.c
--- a/drivers/scsi/qla2xxx/ql2100.c
+++ b/drivers/scsi/qla2xxx/ql2100.c
@@ -1,7 +1,7 @@
 /*
  * QLogic ISP2100 device driver for Linux 2.6.x
  * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff --git a/drivers/scsi/qla2xxx/ql2200.c b/drivers/scsi/qla2xxx/ql2200.c
--- a/drivers/scsi/qla2xxx/ql2200.c
+++ b/drivers/scsi/qla2xxx/ql2200.c
@@ -1,7 +1,7 @@
 /*
  * QLogic ISP2200 device driver for Linux 2.6.x
  * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff --git a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
--- a/drivers/scsi/qla2xxx/ql2300.c
+++ b/drivers/scsi/qla2xxx/ql2300.c
@@ -1,7 +1,7 @@
 /*
  * QLogic ISP2300 device driver for Linux 2.6.x
  * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff --git a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
--- a/drivers/scsi/qla2xxx/ql2322.c
+++ b/drivers/scsi/qla2xxx/ql2322.c
@@ -1,6 +1,6 @@
 /*
  * QLogic ISP2322 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff --git a/drivers/scsi/qla2xxx/ql6312.c b/drivers/scsi/qla2xxx/ql6312.c
--- a/drivers/scsi/qla2xxx/ql6312.c
+++ b/drivers/scsi/qla2xxx/ql6312.c
@@ -1,6 +1,6 @@
 /*
  * QLogic ISP6312 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2,7 +2,7 @@
 *                  QLOGIC LINUX SOFTWARE
 *
 * QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003-2004 QLogic Corporation
+* Copyright (C) 2003-2005 QLogic Corporation
 * (www.qlogic.com)
 *
 * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -3,7 +3,7 @@
 *                  QLOGIC LINUX SOFTWARE
 *
 * QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003-2004 QLogic Corporation
+* Copyright (C) 2003-2005 QLogic Corporation
 * (www.qlogic.com)
 *
 * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -2,7 +2,7 @@
 *                  QLOGIC LINUX SOFTWARE
 *
 * QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003-2004 QLogic Corporation
+* Copyright (C) 2003-2005 QLogic Corporation
 * (www.qlogic.com)
 *
 * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation
+ * Copyright (C) 2003-2005 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it

-- 
Andrew Vasquez
