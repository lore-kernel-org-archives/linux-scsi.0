From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 9/9] - fusion - bump version - 3.04.04
Date: Mon, 29 Jan 2007 09:48:50 -0700
Message-ID: <20070129164850.GA1932@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60772 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbXA2QsO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:48:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

bump version, and fix email addr for lsi support

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2007-01-28 12:57:29.000000000 -0700
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2007-01-28 12:57:29.000000000 -0700
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.03"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.03"
+#define MPT_LINUX_VERSION_COMMON	"3.04.04"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.04"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptctl.c	2007-01-28 12:57:29.000000000 -0700
@@ -5,7 +5,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptctl.h a/drivers/message/fusion/mptctl.h
--- b/drivers/message/fusion/mptctl.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptctl.h	2007-01-28 12:57:29.000000000 -0700
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptfc.c	2007-01-28 12:57:29.000000000 -0700
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptlan.c a/drivers/message/fusion/mptlan.c
--- b/drivers/message/fusion/mptlan.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptlan.c	2007-01-28 12:57:29.000000000 -0700
@@ -5,6 +5,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 2000-2007 LSI Logic Corporation
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptlan.h a/drivers/message/fusion/mptlan.h
--- b/drivers/message/fusion/mptlan.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptlan.h	2007-01-28 12:57:29.000000000 -0700
@@ -5,6 +5,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 2000-2007 LSI Logic Corporation
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *  Copyright (c) 2005-2007 Dell
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-01-28 12:57:29.000000000 -0700
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.h	2007-01-28 12:57:29.000000000 -0700
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2007-01-28 12:57:29.000000000 -0700
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsil.com)
+ *  (mailto:mpt_linux_developer@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
