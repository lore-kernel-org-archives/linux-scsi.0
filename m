From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 22/24] aacraid: Update copyrights
Date: Mon, 23 Jan 2017 10:09:06 -0800
Message-ID: <20170123180908.3465-23-RaghavaAditya.Renukunta@microsemi.com>
References: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0084.outbound.protection.outlook.com ([104.47.36.84]:59982
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751890AbdAXArB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 19:47:01 -0500
In-Reply-To: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Banesh@microsemi.com

Added new copyright messages

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c   |  8 +++++++-
 drivers/scsi/aacraid/aacraid.h  | 32 ++++++++++++++++++++++++++++++++
 drivers/scsi/aacraid/commctrl.c |  3 ++-
 drivers/scsi/aacraid/comminit.c |  3 ++-
 drivers/scsi/aacraid/commsup.c  |  3 ++-
 drivers/scsi/aacraid/dpcsup.c   |  3 ++-
 drivers/scsi/aacraid/linit.c    |  3 ++-
 drivers/scsi/aacraid/nark.c     |  3 ++-
 drivers/scsi/aacraid/rkt.c      |  3 ++-
 drivers/scsi/aacraid/rx.c       |  3 ++-
 drivers/scsi/aacraid/sa.c       |  3 ++-
 drivers/scsi/aacraid/src.c      |  3 ++-
 12 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a89e2a5..d2677cd 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -22,6 +23,11 @@
  * along with this program; see the file COPYING.  If not, write to
  * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  *
+ * Module Name:
+ *  aachba.c
+ *
+ * Abstract: Contains Interfaces to manage IOs.
+ *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 52a2264..58ee1b3 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1,3 +1,35 @@
+/*
+ *	Adaptec AAC series RAID controller driver
+ *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
+ *
+ * based on the old aacraid driver that is..
+ * Adaptec aacraid device driver for Linux.
+ *
+ * Copyright (c) 2000-2010 Adaptec, Inc.
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Module Name:
+ *  aacraid.h
+ *
+ * Abstract: Contains all routines for control of the aacraid driver
+ *
+ */
+
 #ifndef _AACRAID_H_
 #define _AACRAID_H_
 #ifndef dprintk
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 9ade2b4..a704e8d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 407ccf0..ca8f8bd 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index d6e3fa0..0a8a56d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index c426ea2..417ba34 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 99430aa..7465175 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/nark.c b/drivers/scsi/aacraid/nark.c
index 6c53b1d..c59074e 100644
--- a/drivers/scsi/aacraid/nark.c
+++ b/drivers/scsi/aacraid/nark.c
@@ -5,7 +5,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
index d57ac43..0348982 100644
--- a/drivers/scsi/aacraid/rkt.c
+++ b/drivers/scsi/aacraid/rkt.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index a29e0f3..8e79482 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index a03516e..3c2fd28 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index a9ad39d..c3852f4 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -6,7 +6,8 @@
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000-2010 Adaptec, Inc.
- *               2010 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *               2010-2015 PMC-Sierra, Inc. (aacraid@pmc-sierra.com)
+ *		 2016-2017 Microsemi Corp. (aacraid@microsemi.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
2.7.4

