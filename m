From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 6/6] mpt fusion: Changing company name from LSI Logic to LSI
Date: Tue, 14 Aug 2007 16:22:54 +0530
Message-ID: <20070814105253.GF9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39905 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423AbXHNK4T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 06:56:19 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l7EAsl5X025114
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 03:54:47 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

Recently LSI Logic Corp is renamed as LSI Corp, so where ever there is a reference of LSI Logic, they are changed to LSI in mpt fusion driver code.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/lsi/mpi.h b/drivers/message/fusion/lsi/mpi.h
index 6a92e3d..1acbdd6 100644
--- a/drivers/message/fusion/lsi/mpi.h
+++ b/drivers/message/fusion/lsi/mpi.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2007 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Corporation.
  *
  *
  *           Name:  mpi.h
diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index eda7697..2bd8ada 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2007 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Corporation.
  *
  *
  *           Name:  mpi_cnfg.h
diff --git a/drivers/message/fusion/lsi/mpi_fc.h b/drivers/message/fusion/lsi/mpi_fc.h
index 51a6aeb..627acfb 100644
--- a/drivers/message/fusion/lsi/mpi_fc.h
+++ b/drivers/message/fusion/lsi/mpi_fc.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2004 LSI Logic Corporation.
+ *  Copyright (c) 2000-2004 LSI Corporation.
  *
  *
  *           Name:  mpi_fc.h
diff --git a/drivers/message/fusion/lsi/mpi_history.txt b/drivers/message/fusion/lsi/mpi_history.txt
index a1f4790..241592a 100644
--- a/drivers/message/fusion/lsi/mpi_history.txt
+++ b/drivers/message/fusion/lsi/mpi_history.txt
@@ -3,7 +3,7 @@
  MPI Header File Change History
  ==============================
 
- Copyright (c) 2000-2007 LSI Logic Corporation.
+ Copyright (c) 2000-2007 LSI Corporation.
 
  ---------------------------------------
  Header Set Release Version:    01.05.16
diff --git a/drivers/message/fusion/lsi/mpi_init.h b/drivers/message/fusion/lsi/mpi_init.h
index 3a02615..a9e3693 100644
--- a/drivers/message/fusion/lsi/mpi_init.h
+++ b/drivers/message/fusion/lsi/mpi_init.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2007 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Corporation.
  *
  *
  *           Name:  mpi_init.h
diff --git a/drivers/message/fusion/lsi/mpi_ioc.h b/drivers/message/fusion/lsi/mpi_ioc.h
index b1893d1..5cbb6bd 100644
--- a/drivers/message/fusion/lsi/mpi_ioc.h
+++ b/drivers/message/fusion/lsi/mpi_ioc.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2007 LSI Logic Corporation.
+ *  Copyright (c) 2000-2007 LSI Corporation.
  *
  *
  *           Name:  mpi_ioc.h
diff --git a/drivers/message/fusion/lsi/mpi_lan.h b/drivers/message/fusion/lsi/mpi_lan.h
index dc0b52a..03253b5 100644
--- a/drivers/message/fusion/lsi/mpi_lan.h
+++ b/drivers/message/fusion/lsi/mpi_lan.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2004 LSI Logic Corporation.
+ *  Copyright (c) 2000-2004 LSI Corporation.
  *
  *
  *           Name:  mpi_lan.h
diff --git a/drivers/message/fusion/lsi/mpi_log_fc.h b/drivers/message/fusion/lsi/mpi_log_fc.h
index dc98d46..e4dafce 100644
--- a/drivers/message/fusion/lsi/mpi_log_fc.h
+++ b/drivers/message/fusion/lsi/mpi_log_fc.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2001 LSI Logic Corporation. All rights reserved.
+ *  Copyright (c) 2000-2001 LSI Corporation. All rights reserved.
  *
  *  NAME:           fc_log.h
  *  SUMMARY:        MPI IocLogInfo definitions for the SYMFC9xx chips
diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
index 635bbe0..6be1f6b 100644
--- a/drivers/message/fusion/lsi/mpi_log_sas.h
+++ b/drivers/message/fusion/lsi/mpi_log_sas.h
@@ -1,6 +1,6 @@
 /***************************************************************************
  *                                                                         *
- *  Copyright 2003 LSI Logic Corporation.  All rights reserved.            *
+ *  Copyright 2003 LSI Corporation.  All rights reserved.            *
  *                                                                         *
  * Description                                                             *
  * ------------                                                            *
diff --git a/drivers/message/fusion/lsi/mpi_raid.h b/drivers/message/fusion/lsi/mpi_raid.h
index 32819b1..2856108 100644
--- a/drivers/message/fusion/lsi/mpi_raid.h
+++ b/drivers/message/fusion/lsi/mpi_raid.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2001-2007 LSI Logic Corporation.
+ *  Copyright (c) 2001-2007 LSI Corporation.
  *
  *
  *           Name:  mpi_raid.h
diff --git a/drivers/message/fusion/lsi/mpi_sas.h b/drivers/message/fusion/lsi/mpi_sas.h
index 8e990a0..33fca83 100644
--- a/drivers/message/fusion/lsi/mpi_sas.h
+++ b/drivers/message/fusion/lsi/mpi_sas.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2004-2006 LSI Logic Corporation.
+ *  Copyright (c) 2004-2006 LSI Corporation.
  *
  *
  *           Name:  mpi_sas.h
diff --git a/drivers/message/fusion/lsi/mpi_targ.h b/drivers/message/fusion/lsi/mpi_targ.h
index 20b6673..ff8c37d 100644
--- a/drivers/message/fusion/lsi/mpi_targ.h
+++ b/drivers/message/fusion/lsi/mpi_targ.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2004 LSI Logic Corporation.
+ *  Copyright (c) 2000-2004 LSI Corporation.
  *
  *
  *           Name:  mpi_targ.h
diff --git a/drivers/message/fusion/lsi/mpi_tool.h b/drivers/message/fusion/lsi/mpi_tool.h
index aa9053d..8834ae6 100644
--- a/drivers/message/fusion/lsi/mpi_tool.h
+++ b/drivers/message/fusion/lsi/mpi_tool.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2001-2005 LSI Logic Corporation.
+ *  Copyright (c) 2001-2005 LSI Corporation.
  *
  *
  *           Name:  mpi_tool.h
diff --git a/drivers/message/fusion/lsi/mpi_type.h b/drivers/message/fusion/lsi/mpi_type.h
index 32cc9b1..08dad9c 100644
--- a/drivers/message/fusion/lsi/mpi_type.h
+++ b/drivers/message/fusion/lsi/mpi_type.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2004 LSI Logic Corporation.
+ *  Copyright (c) 2000-2004 LSI Corporation.
  *
  *
  *           Name:  mpi_type.h
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 71d967d..2996ea6 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2,10 +2,10 @@
  *  linux/drivers/message/fusion/mptbase.c
  *      This is the Fusion MPT base driver which supports multiple
  *      (SCSI + LAN) specialized protocol drivers.
- *      For use with LSI Logic PCI chip/adapter(s)
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI PCI chip/adapter(s)
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 1197eba..53f7e38 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -3,9 +3,9 @@
  *      High performance SCSI + LAN / Fibre Channel device drivers.
  *      For use with PCI chip/adapter(s):
  *          LSIFC9xx/LSI409xx Fibre Channel
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
@@ -68,7 +68,7 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
 #ifndef MODULEAUTHOR
-#define MODULEAUTHOR	"LSI Logic Corporation"
+#define MODULEAUTHOR	"LSI Corporation"
 #endif
 
 #ifndef COPYRIGHT
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 0801b30..88d4b33 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1,10 +1,10 @@
 /*
  *  linux/drivers/message/fusion/mptctl.c
  *      mpt Ioctl driver.
- *      For use with LSI Logic PCI chip/adapters
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI PCI chip/adapters
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
@@ -66,8 +66,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
-#define COPYRIGHT	"Copyright (c) 1999-2007 LSI Logic Corporation"
-#define MODULEAUTHOR	"LSI Logic Corporation"
+#define COPYRIGHT	"Copyright (c) 1999-2007 LSI Corporation"
+#define MODULEAUTHOR	"LSI Corporation"
 #include "mptbase.h"
 #include "mptctl.h"
 
diff --git a/drivers/message/fusion/mptctl.h b/drivers/message/fusion/mptctl.h
index 180b3c1..2c18901 100644
--- a/drivers/message/fusion/mptctl.h
+++ b/drivers/message/fusion/mptctl.h
@@ -3,9 +3,9 @@
  *      Fusion MPT misc device (ioctl) driver.
  *      For use with PCI chip/adapter(s):
  *          LSIFC9xx/LSI409xx Fibre Channel
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index aadb071..0586f87 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1,9 +1,9 @@
 /*
  *  linux/drivers/message/fusion/mptfc.c
- *      For use with LSI Logic PCI chip/adapter(s)
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI PCI chip/adapter(s)
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 9d9eb76..952e148 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -1,10 +1,10 @@
 /*
  *  linux/drivers/message/fusion/mptlan.c
  *      IP Over Fibre Channel device driver.
- *      For use with LSI Logic Fibre Channel PCI chip/adapters
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI Fibre Channel PCI chip/adapters
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 2000-2007 LSI Logic Corporation
+ *  Copyright (c) 2000-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptlan.h b/drivers/message/fusion/mptlan.h
index 8d08c2b..bafb67f 100644
--- a/drivers/message/fusion/mptlan.h
+++ b/drivers/message/fusion/mptlan.h
@@ -1,10 +1,10 @@
 /*
  *  linux/drivers/message/fusion/mptlan.h
  *      IP Over Fibre Channel device driver.
- *      For use with LSI Logic Fibre Channel PCI chip/adapters
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI Fibre Channel PCI chip/adapters
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 2000-2007 LSI Logic Corporation
+ *  Copyright (c) 2000-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
@@ -75,7 +75,7 @@
 #include <asm/io.h>
 
     /* Override mptbase.h by pre-defining these! */
-#define MODULEAUTHOR	"LSI Logic Corporation"
+#define MODULEAUTHOR	"LSI Corporation"
 
 #include "mptbase.h"
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5951fe0..4333449 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1,9 +1,9 @@
 /*
  *  linux/drivers/message/fusion/mptsas.c
- *      For use with LSI Logic PCI chip/adapter(s)
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI PCI chip/adapter(s)
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *  Copyright (c) 2005-2007 Dell
  */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index b8b0598..f00c100 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1,9 +1,9 @@
 /*
  *  linux/drivers/message/fusion/mptscsih.c
- *      For use with LSI Logic PCI chip/adapter(s)
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI PCI chip/adapter(s)
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 67b088d..d289e97 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -3,9 +3,9 @@
  *      High performance SCSI / Fibre Channel SCSI Host device driver.
  *      For use with PCI chip/adapter(s):
  *          LSIFC9xx/LSI409xx Fibre Channel
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 406d045..fdfbffb 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1,9 +1,9 @@
 /*
  *  linux/drivers/message/fusion/mptspi.c
- *      For use with LSI Logic PCI chip/adapter(s)
- *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
+ *      For use with LSI PCI chip/adapter(s)
+ *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
