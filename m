From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [1/15] qla2xxx:  Update copyright banner
Date: Sun, 14 Mar 2004 00:24:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082404.GA3388@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:61336 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263313AbUCNIVg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:21:36 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1657 04/02/28 20:30:48 andrew.vasquez@qlogic.com +29 -0
  Update copyright banner for all source files.

 drivers/scsi/qla2xxx/ql2100.c       |    2 +-
 drivers/scsi/qla2xxx/ql2100_fw.c    |    2 +-
 drivers/scsi/qla2xxx/ql2200.c       |    2 +-
 drivers/scsi/qla2xxx/ql2200_fw.c    |    2 +-
 drivers/scsi/qla2xxx/ql2300.c       |    2 +-
 drivers/scsi/qla2xxx/ql2300_fw.c    |    2 +-
 drivers/scsi/qla2xxx/ql2322.c       |    2 +-
 drivers/scsi/qla2xxx/ql2322_fw.c    |    2 +-
 drivers/scsi/qla2xxx/ql6312.c       |    2 +-
 drivers/scsi/qla2xxx/ql6312_fw.c    |    2 +-
 drivers/scsi/qla2xxx/ql6322.c       |    2 +-
 drivers/scsi/qla2xxx/ql6322_fw.c    |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c      |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_def.h      |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c       |    2 +-
 drivers/scsi/qla2xxx/qla_init.c     |    2 +-
 drivers/scsi/qla2xxx/qla_inline.h   |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c      |    2 +-
 drivers/scsi/qla2xxx/qla_listops.h  |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c       |    2 +-
 drivers/scsi/qla2xxx/qla_os.h       |    2 +-
 drivers/scsi/qla2xxx/qla_rscn.c     |    2 +-
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |    2 +-
 drivers/scsi/qla2xxx/qla_version.h  |    2 +-
 29 files changed, 29 insertions(+), 29 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/10_cright_update.patch

diff -Nru a/drivers/scsi/qla2xxx/ql2100.c b/drivers/scsi/qla2xxx/ql2100.c
--- a/drivers/scsi/qla2xxx/ql2100.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql2100.c	Fri Mar 12 17:06:10 2004
@@ -1,7 +1,7 @@
 /*
  * QLogic ISP2100 device driver for Linux 2.6.x
  * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff -Nru a/drivers/scsi/qla2xxx/ql2100_fw.c b/drivers/scsi/qla2xxx/ql2100_fw.c
--- a/drivers/scsi/qla2xxx/ql2100_fw.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql2100_fw.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/ql2200.c b/drivers/scsi/qla2xxx/ql2200.c
--- a/drivers/scsi/qla2xxx/ql2200.c	Fri Mar 12 17:06:09 2004
+++ b/drivers/scsi/qla2xxx/ql2200.c	Fri Mar 12 17:06:09 2004
@@ -1,7 +1,7 @@
 /*
  * QLogic ISP2200 device driver for Linux 2.6.x
  * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff -Nru a/drivers/scsi/qla2xxx/ql2200_fw.c b/drivers/scsi/qla2xxx/ql2200_fw.c
--- a/drivers/scsi/qla2xxx/ql2200_fw.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql2200_fw.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
--- a/drivers/scsi/qla2xxx/ql2300.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql2300.c	Fri Mar 12 17:06:10 2004
@@ -1,7 +1,7 @@
 /*
  * QLogic ISP2300 device driver for Linux 2.6.x
  * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff -Nru a/drivers/scsi/qla2xxx/ql2300_fw.c b/drivers/scsi/qla2xxx/ql2300_fw.c
--- a/drivers/scsi/qla2xxx/ql2300_fw.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql2300_fw.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
--- a/drivers/scsi/qla2xxx/ql2322.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql2322.c	Fri Mar 12 17:06:10 2004
@@ -1,6 +1,6 @@
 /*
  * QLogic ISP2322 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff -Nru a/drivers/scsi/qla2xxx/ql2322_fw.c b/drivers/scsi/qla2xxx/ql2322_fw.c
--- a/drivers/scsi/qla2xxx/ql2322_fw.c	Fri Mar 12 17:06:09 2004
+++ b/drivers/scsi/qla2xxx/ql2322_fw.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/ql6312.c b/drivers/scsi/qla2xxx/ql6312.c
--- a/drivers/scsi/qla2xxx/ql6312.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql6312.c	Fri Mar 12 17:06:10 2004
@@ -1,6 +1,6 @@
 /*
  * QLogic ISP6312 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff -Nru a/drivers/scsi/qla2xxx/ql6312_fw.c b/drivers/scsi/qla2xxx/ql6312_fw.c
--- a/drivers/scsi/qla2xxx/ql6312_fw.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql6312_fw.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/ql6322.c b/drivers/scsi/qla2xxx/ql6322.c
--- a/drivers/scsi/qla2xxx/ql6322.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql6322.c	Fri Mar 12 17:06:10 2004
@@ -1,6 +1,6 @@
 /*
  * QLogic ISP6322 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
  *
  * Released under GPL v2.
  */
diff -Nru a/drivers/scsi/qla2xxx/ql6322_fw.c b/drivers/scsi/qla2xxx/ql6322_fw.c
--- a/drivers/scsi/qla2xxx/ql6322_fw.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/ql6322_fw.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_dbg.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
--- a/drivers/scsi/qla2xxx/qla_dbg.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_dbg.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
 *                  QLOGIC LINUX SOFTWARE
 *
 * QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003 QLogic Corporation
+* Copyright (C) 2003-2004 QLogic Corporation
 * (www.qlogic.com)
 *
 * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
 *                  QLOGIC LINUX SOFTWARE
 *
 * QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003 QLogic Corporation
+* Copyright (C) 2003-2004 QLogic Corporation
 * (www.qlogic.com)
 *
 * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
--- a/drivers/scsi/qla2xxx/qla_gs.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_gs.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_inline.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_isr.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_listops.h b/drivers/scsi/qla2xxx/qla_listops.h
--- a/drivers/scsi/qla2xxx/qla_listops.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_listops.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_os.h b/drivers/scsi/qla2xxx/qla_os.h
--- a/drivers/scsi/qla2xxx/qla_os.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_os.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * Portions (C) Arjan van de Ven <arjanv@redhat.com> for Red Hat, Inc.
diff -Nru a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_rscn.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
--- a/drivers/scsi/qla2xxx/qla_settings.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_settings.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_sup.c	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
diff -Nru a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h	Fri Mar 12 17:06:10 2004
+++ b/drivers/scsi/qla2xxx/qla_version.h	Fri Mar 12 17:06:10 2004
@@ -2,7 +2,7 @@
  *                  QLOGIC LINUX SOFTWARE
  *
  * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003 QLogic Corporation
+ * Copyright (C) 2003-2004 QLogic Corporation
  * (www.qlogic.com)
  *
  * This program is free software; you can redistribute it and/or modify it
