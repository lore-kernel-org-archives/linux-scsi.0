From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 2/6] mpt fusion : Updated copyright statment with 2008 included
Date: Wed, 21 May 2008 00:56:41 +0530
Message-ID: <20080520192640.GC11542@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42483 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbYETTfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 15:35:19 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m4KJVWAw019711
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 12:31:32 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com


Updating copyright statement to include the year 2008

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/lsi/mpi.h b/drivers/message/fusion/lsi/mpi.h
index 1acbdd6..10b6ef7 100644
--- a/drivers/message/fusion/lsi/mpi.h
+++ b/drivers/message/fusion/lsi/mpi.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2007 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi.h
diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 2bd8ada..b2db333 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1,5 +1,5 @@
 /*
- *  Copyright (c) 2000-2007 LSI Corporation.
+ *  Copyright (c) 2000-2008 LSI Corporation.
  *
  *
  *           Name:  mpi_cnfg.h
diff --git a/drivers/message/fusion/lsi/mpi_fc.h b/drivers/message/fusion/lsi/mpi_fc.h
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index db3c892..9538df2 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -5,7 +5,7 @@
  *      For use with LSI PCI chip/adapter(s)
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 62ace8d..c8671a3 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -5,7 +5,7 @@
  *          LSIFC9xx/LSI409xx Fibre Channel
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
@@ -73,7 +73,7 @@
 #endif
 
 #ifndef COPYRIGHT
-#define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
+#define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
 #define MPT_LINUX_VERSION_COMMON	"3.04.07"
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index e630b50..68c844b 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -4,7 +4,7 @@
  *      For use with LSI PCI chip/adapters
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
@@ -66,7 +66,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
-#define COPYRIGHT	"Copyright (c) 1999-2007 LSI Corporation"
+#define COPYRIGHT	"Copyright (c) 1999-2008 LSI Corporation"
 #define MODULEAUTHOR	"LSI Corporation"
 #include "mptbase.h"
 #include "mptctl.h"
diff --git a/drivers/message/fusion/mptctl.h b/drivers/message/fusion/mptctl.h
index 2c18901..d564cc9 100644
--- a/drivers/message/fusion/mptctl.h
+++ b/drivers/message/fusion/mptctl.h
@@ -5,7 +5,7 @@
  *          LSIFC9xx/LSI409xx Fibre Channel
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptdebug.h b/drivers/message/fusion/mptdebug.h
index ffdb0a6..510b9f4 100644
--- a/drivers/message/fusion/mptdebug.h
+++ b/drivers/message/fusion/mptdebug.h
@@ -3,7 +3,7 @@
  *      For use with LSI PCI chip/adapter(s)
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 3cdd4e9..f60f134 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -3,7 +3,7 @@
  *      For use with LSI PCI chip/adapter(s)
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index 7950fc6..d709d92 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -4,7 +4,7 @@
  *      For use with LSI Fibre Channel PCI chip/adapters
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 2000-2007 LSI Corporation
+ *  Copyright (c) 2000-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptlan.h b/drivers/message/fusion/mptlan.h
index bafb67f..33927ee 100644
--- a/drivers/message/fusion/mptlan.h
+++ b/drivers/message/fusion/mptlan.h
@@ -4,7 +4,7 @@
  *      For use with LSI Fibre Channel PCI chip/adapters
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 2000-2007 LSI Corporation
+ *  Copyright (c) 2000-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 4684807..0cbb562 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3,7 +3,7 @@
  *      For use with LSI PCI chip/adapter(s)
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/message/fusion/mptsas.h b/drivers/message/fusion/mptsas.h
index 7c150f5..2b544e0 100644
--- a/drivers/message/fusion/mptsas.h
+++ b/drivers/message/fusion/mptsas.h
@@ -5,7 +5,7 @@
  *          LSIFC9xx/LSI409xx Fibre Channel
  *      running LSI MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index b109bd8..63a5199 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -3,7 +3,7 @@
  *      For use with LSI PCI chip/adapter(s)
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 7ea7da0..319aa30 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -5,7 +5,7 @@
  *          LSIFC9xx/LSI409xx Fibre Channel
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 25bcfcf..1cdea1a 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -3,7 +3,7 @@
  *      For use with LSI PCI chip/adapter(s)
  *      running LSI Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2007 LSI Corporation
+ *  Copyright (c) 1999-2008 LSI Corporation
  *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
