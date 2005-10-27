From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/5]  qla2xxx: Update license.
Date: Thu, 27 Oct 2005 11:10:08 -0700 (PDT)
Message-ID: <20051027181008.11768.72688.sendpatchset@plap.qlogic.com>
References: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:64361 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751429AbVJ0SKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 14:10:10 -0400
In-Reply-To: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 Documentation/scsi/LICENSE.qla2xxx  |   45 +++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/ql2100.c       |    9 +++----
 drivers/scsi/qla2xxx/ql2100_fw.c    |   22 ++++-------------
 drivers/scsi/qla2xxx/ql2200.c       |    9 +++----
 drivers/scsi/qla2xxx/ql2200_fw.c    |   22 ++++-------------
 drivers/scsi/qla2xxx/ql2300.c       |    9 +++----
 drivers/scsi/qla2xxx/ql2300_fw.c    |   22 ++++-------------
 drivers/scsi/qla2xxx/ql2322.c       |    7 ++---
 drivers/scsi/qla2xxx/ql2322_fw.c    |   22 ++++-------------
 drivers/scsi/qla2xxx/ql6312.c       |    7 ++---
 drivers/scsi/qla2xxx/ql6312_fw.c    |   22 ++++-------------
 drivers/scsi/qla2xxx/qla_attr.c     |   18 ++------------
 drivers/scsi/qla2xxx/qla_dbg.c      |   18 ++------------
 drivers/scsi/qla2xxx/qla_dbg.h      |   23 ++++--------------
 drivers/scsi/qla2xxx/qla_def.h      |   25 +++++--------------
 drivers/scsi/qla2xxx/qla_fw.h       |   26 +++++---------------
 drivers/scsi/qla2xxx/qla_gbl.h      |   28 +++++-----------------
 drivers/scsi/qla2xxx/qla_gs.c       |   18 ++------------
 drivers/scsi/qla2xxx/qla_init.c     |   18 ++------------
 drivers/scsi/qla2xxx/qla_inline.h   |   19 ++-------------
 drivers/scsi/qla2xxx/qla_iocb.c     |   23 ++++--------------
 drivers/scsi/qla2xxx/qla_isr.c      |   18 ++------------
 drivers/scsi/qla2xxx/qla_mbx.c      |   18 ++------------
 drivers/scsi/qla2xxx/qla_os.c       |   18 ++------------
 drivers/scsi/qla2xxx/qla_rscn.c     |   18 ++------------
 drivers/scsi/qla2xxx/qla_settings.h |   22 ++++-------------
 drivers/scsi/qla2xxx/qla_sup.c      |   23 ++++--------------
 drivers/scsi/qla2xxx/qla_version.h  |   22 ++++-------------
 28 files changed, 158 insertions(+), 393 deletions(-)
 create mode 100644 Documentation/scsi/LICENSE.qla2xxx

9ddcb37481c2780bea2189d7e4bec913eeea8c58
diff --git a/Documentation/scsi/LICENSE.qla2xxx b/Documentation/scsi/LICENSE.qla2xxx
new file mode 100644
index 0000000..9e15b4f
--- /dev/null
+++ b/Documentation/scsi/LICENSE.qla2xxx
@@ -0,0 +1,45 @@
+Copyright (c)  2003-2005 QLogic Corporation
+QLogic Linux Fibre Channel HBA Driver
+
+This program includes a device driver for Linux 2.6 that may be
+distributed with QLogic hardware specific firmware binary file.
+You may modify and redistribute the device driver code under the
+GNU General Public License as published by the Free Software
+Foundation (version 2 or a later version).
+
+You may redistribute the hardware specific firmware binary file
+under the following terms:
+
+	1. Redistribution of source code (only if applicable),
+	   must retain the above copyright notice, this list of
+	   conditions and the following disclaimer.
+
+	2. Redistribution in binary form must reproduce the above
+	   copyright notice, this list of conditions and the
+	   following disclaimer in the documentation and/or other
+	   materials provided with the distribution.
+
+	3. The name of QLogic Corporation may not be used to
+	   endorse or promote products derived from this software
+	   without specific prior written permission
+
+REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGE.
+
+USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+COMBINATION WITH THIS PROGRAM.
diff --git a/drivers/scsi/qla2xxx/ql2100.c b/drivers/scsi/qla2xxx/ql2100.c
index 058733d..f5db223 100644
--- a/drivers/scsi/qla2xxx/ql2100.c
+++ b/drivers/scsi/qla2xxx/ql2100.c
@@ -1,11 +1,10 @@
 /*
- * QLogic ISP2100 device driver for Linux 2.6.x
- * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (C)  2003 Christoph Hellwig.
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- * Released under GPL v2.
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/ql2100_fw.c b/drivers/scsi/qla2xxx/ql2100_fw.c
index 18376b8..5600616 100644
--- a/drivers/scsi/qla2xxx/ql2100_fw.c
+++ b/drivers/scsi/qla2xxx/ql2100_fw.c
@@ -1,21 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- *************************************************************************/
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 
 /*
  *	Firmware Version 1.19.25 (13:12 Dec 10, 2003)
diff --git a/drivers/scsi/qla2xxx/ql2200.c b/drivers/scsi/qla2xxx/ql2200.c
index 5b5ee73..0eef72d 100644
--- a/drivers/scsi/qla2xxx/ql2200.c
+++ b/drivers/scsi/qla2xxx/ql2200.c
@@ -1,11 +1,10 @@
 /*
- * QLogic ISP2200 device driver for Linux 2.6.x
- * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (C)  2003 Christoph Hellwig.
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- * Released under GPL v2.
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/ql2200_fw.c b/drivers/scsi/qla2xxx/ql2200_fw.c
index 6f103fd..ac07e18 100644
--- a/drivers/scsi/qla2xxx/ql2200_fw.c
+++ b/drivers/scsi/qla2xxx/ql2200_fw.c
@@ -1,21 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- *************************************************************************/
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 
 /*
  *	Firmware Version 2.02.08 (17:06 Mar 22, 2005)
diff --git a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
index 22371c8..fd2f4b7 100644
--- a/drivers/scsi/qla2xxx/ql2300.c
+++ b/drivers/scsi/qla2xxx/ql2300.c
@@ -1,11 +1,10 @@
 /*
- * QLogic ISP2300 device driver for Linux 2.6.x
- * Copyright (C) 2003 Christoph Hellwig.
- * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (C)  2003 Christoph Hellwig.
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- * Released under GPL v2.
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/ql2300_fw.c b/drivers/scsi/qla2xxx/ql2300_fw.c
index 4917ec5..1896a0e 100644
--- a/drivers/scsi/qla2xxx/ql2300_fw.c
+++ b/drivers/scsi/qla2xxx/ql2300_fw.c
@@ -1,21 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- ******************************************************************************/
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 
 /*
  *	Firmware Version 3.03.15 (10:03 May 26, 2005)
diff --git a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
index bfe918a..c88a22c 100644
--- a/drivers/scsi/qla2xxx/ql2322.c
+++ b/drivers/scsi/qla2xxx/ql2322.c
@@ -1,10 +1,9 @@
 /*
- * QLogic ISP2322 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- * Released under GPL v2.
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/ql2322_fw.c b/drivers/scsi/qla2xxx/ql2322_fw.c
index 2645d62..97b5578 100644
--- a/drivers/scsi/qla2xxx/ql2322_fw.c
+++ b/drivers/scsi/qla2xxx/ql2322_fw.c
@@ -1,21 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- ******************************************************************************/
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 
 /*
  *	Firmware Version 3.03.15 (10:09 May 26, 2005)
diff --git a/drivers/scsi/qla2xxx/ql6312.c b/drivers/scsi/qla2xxx/ql6312.c
index e75882d..de55397 100644
--- a/drivers/scsi/qla2xxx/ql6312.c
+++ b/drivers/scsi/qla2xxx/ql6312.c
@@ -1,10 +1,9 @@
 /*
- * QLogic ISP6312 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation (www.qlogic.com)
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- * Released under GPL v2.
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
-
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/ql6312_fw.c b/drivers/scsi/qla2xxx/ql6312_fw.c
index 3579809..1f8744a 100644
--- a/drivers/scsi/qla2xxx/ql6312_fw.c
+++ b/drivers/scsi/qla2xxx/ql6312_fw.c
@@ -1,21 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- ******************************************************************************/
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 
 /*
  *	Firmware Version 3.03.15 (10:00 May 26, 2005)
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 47c9ecf..49696fa 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9791496..89793c1 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 9684e7a..935a59a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -1,22 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- ******************************************************************************/
-
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 /*
  * Driver debug definitions.
  */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0821b05..7096945 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1,22 +1,9 @@
-/********************************************************************************
-*                  QLOGIC LINUX SOFTWARE
-*
-* QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003-2005 QLogic Corporation
-* (www.qlogic.com)
-*
-* This program is free software; you can redistribute it and/or modify it
-* under the terms of the GNU General Public License as published by the
-* Free Software Foundation; either version 2, or (at your option) any
-* later version.
-*
-* This program is distributed in the hope that it will be useful, but
-* WITHOUT ANY WARRANTY; without even the implied warranty of
-* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-* General Public License for more details.
-**
-******************************************************************************/
-
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 #ifndef __QLA_DEF_H
 #define __QLA_DEF_H
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 63f6119..9fb562a 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1,23 +1,9 @@
-
-/********************************************************************************
-*                  QLOGIC LINUX SOFTWARE
-*
-* QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003-2005 QLogic Corporation
-* (www.qlogic.com)
-*
-* This program is free software; you can redistribute it and/or modify it
-* under the terms of the GNU General Public License as published by the
-* Free Software Foundation; either version 2, or (at your option) any
-* later version.
-*
-* This program is distributed in the hope that it will be useful, but
-* WITHOUT ANY WARRANTY; without even the implied warranty of
-* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-* General Public License for more details.
-**
-******************************************************************************/
-
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 #ifndef __QLA_FW_H
 #define __QLA_FW_H
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 7680b95..ba44636 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -1,25 +1,9 @@
-/********************************************************************************
-*                  QLOGIC LINUX SOFTWARE
-*
-* QLogic ISP2x00 device driver for Linux 2.6.x
-* Copyright (C) 2003-2005 QLogic Corporation
-* (www.qlogic.com)
-*
-* This program is free software; you can redistribute it and/or modify it
-* under the terms of the GNU General Public License as published by the
-* Free Software Foundation; either version 2, or (at your option) any
-* later version.
-*
-* This program is distributed in the hope that it will be useful, but
-* WITHOUT ANY WARRANTY; without even the implied warranty of
-* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-* General Public License for more details.
-*
-******************************************************************************
-* Global include file.
-******************************************************************************/
-
-
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 #ifndef __QLA_GBL_H
 #define	__QLA_GBL_H
 
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e7b138c..cd6f7c3 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5c35408..e4a1dec 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index b9ff85b..ecc3741 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -1,23 +1,10 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 
-
 static __inline__ uint16_t qla2x00_debounce_register(volatile uint16_t __iomem *);
 /*
  * qla2x00_debounce_register
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b58ee79..17f5697 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1,22 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- ******************************************************************************/
-
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 #include "qla_def.h"
 
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index cf6c6ce..09afc0f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 13e1c90..ad3cacb 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8226fa2..5a0b2a4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
index 2f04a5f..9c51d66 100644
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -1,20 +1,8 @@
 /*
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
+ * See LICENSE.qla2xxx for copyright and licensing details.
  */
 #include "qla_def.h"
 
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
index d85fbbe..363205c 100644
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -1,21 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- ******************************************************************************/
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 /*
  * Compile time Options:
  *     0 - Disable and 1 - Enable
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index c14abf7..4bec0b4 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1,22 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- ******************************************************************************/
-
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 #include "qla_def.h"
 
 #include <linux/delay.h>
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index eae7d6e..0d5472f 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -1,21 +1,9 @@
-/******************************************************************************
- *                  QLOGIC LINUX SOFTWARE
- *
- * QLogic ISP2x00 device driver for Linux 2.6.x
- * Copyright (C) 2003-2005 QLogic Corporation
- * (www.qlogic.com)
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
  *
- ******************************************************************************/
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
 /*
  * Driver version
  */

-- 
Andrew Vasquez
