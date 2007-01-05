From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 4/5] fusion: MODULE_VERSION support
Date: Thu, 4 Jan 2007 20:47:47 -0700
Message-ID: <20070105034747.GA14126@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43940 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030316AbXAEDqB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 22:46:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

* Add modinfo driver version support.
* Change copyright year to 2007.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2006-12-25 01:42:17.000000000 -0700
@@ -5,7 +5,7 @@
  *      For use with LSI Logic PCI chip/adapter(s)
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
@@ -73,6 +73,7 @@
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(my_VERSION);
 
 /*
  *  cmd line parameters
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-12-25 00:35:10.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2006-12-25 01:41:05.000000000 -0700
@@ -5,7 +5,7 @@
  *          LSIFC9xx/LSI409xx Fibre Channel
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
@@ -72,7 +72,7 @@
 #endif
 
 #ifndef COPYRIGHT
-#define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
+#define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
 #endif
 
 #define MPT_LINUX_VERSION_COMMON	"3.04.02"
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptctl.c	2006-12-25 01:42:25.000000000 -0700
@@ -4,7 +4,7 @@
  *      For use with LSI Logic PCI chip/adapters
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
@@ -66,7 +66,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 
-#define COPYRIGHT	"Copyright (c) 1999-2005 LSI Logic Corporation"
+#define COPYRIGHT	"Copyright (c) 1999-2007 LSI Logic Corporation"
 #define MODULEAUTHOR	"LSI Logic Corporation"
 #include "mptbase.h"
 #include "mptctl.h"
@@ -79,6 +79,7 @@
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(my_VERSION);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
diff -uarpN b/drivers/message/fusion/mptctl.h a/drivers/message/fusion/mptctl.h
--- b/drivers/message/fusion/mptctl.h	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptctl.h	2006-12-25 01:39:58.000000000 -0700
@@ -5,7 +5,7 @@
  *          LSIFC9xx/LSI409xx Fibre Channel
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptfc.c	2006-12-25 01:42:34.000000000 -0700
@@ -3,7 +3,7 @@
  *      For use with LSI Logic PCI chip/adapter(s)
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
@@ -75,6 +75,7 @@
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(my_VERSION);
 
 /* Command line args */
 #define MPTFC_DEV_LOSS_TMO (60)
diff -uarpN b/drivers/message/fusion/mptlan.c a/drivers/message/fusion/mptlan.c
--- b/drivers/message/fusion/mptlan.c	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptlan.c	2006-12-25 01:44:32.000000000 -0700
@@ -4,7 +4,7 @@
  *      For use with LSI Logic Fibre Channel PCI chip/adapters
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 2000-2005 LSI Logic Corporation
+ *  Copyright (c) 2000-2007 LSI Logic Corporation
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -56,9 +56,11 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 
+#define my_VERSION	MPT_LINUX_VERSION_COMMON
 #define MYNAM		"mptlan"
 
 MODULE_LICENSE("GPL");
+MODULE_VERSION(my_VERSION);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
diff -uarpN b/drivers/message/fusion/mptlan.h a/drivers/message/fusion/mptlan.h
--- b/drivers/message/fusion/mptlan.h	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptlan.h	2006-12-25 01:40:12.000000000 -0700
@@ -4,7 +4,7 @@
  *      For use with LSI Logic Fibre Channel PCI chip/adapters
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 2000-2005 LSI Logic Corporation
+ *  Copyright (c) 2000-2007 LSI Logic Corporation
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-12-25 00:54:43.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2006-12-25 01:42:40.000000000 -0700
@@ -3,9 +3,9 @@
  *      For use with LSI Logic PCI chip/adapter(s)
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
- *  Copyright (c) 2005-2006 Dell
+ *  Copyright (c) 2005-2007 Dell
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -75,6 +75,7 @@
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(my_VERSION);
 
 static int mpt_pt_clear;
 module_param(mpt_pt_clear, int, 0);
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-12-25 01:55:24.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2006-12-25 01:55:45.000000000 -0700
@@ -3,7 +3,7 @@
  *      For use with LSI Logic PCI chip/adapter(s)
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
@@ -76,6 +76,7 @@
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(my_VERSION);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
diff -uarpN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.h	2006-12-25 01:40:30.000000000 -0700
@@ -5,7 +5,7 @@
  *          LSIFC9xx/LSI409xx Fibre Channel
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2006-12-25 01:42:51.000000000 -0700
@@ -3,7 +3,7 @@
  *      For use with LSI Logic PCI chip/adapter(s)
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
- *  Copyright (c) 1999-2005 LSI Logic Corporation
+ *  Copyright (c) 1999-2007 LSI Logic Corporation
  *  (mailto:mpt_linux_developer@lsil.com)
  *
  */
@@ -77,6 +77,7 @@
 MODULE_AUTHOR(MODULEAUTHOR);
 MODULE_DESCRIPTION(my_NAME);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(my_VERSION);
 
 /* Command line args */
 static int mpt_saf_te = MPTSCSIH_SAF_TE;
