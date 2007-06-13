From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/6] mpt fusion: update MAINTAINERS (fusion part)
Date: Wed, 13 Jun 2007 16:31:07 -0600
Message-ID: <20070613223107.GA21005@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35513 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbXFMWfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:35:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, DL-MPTFusionLinux@lsi.com

Update assocated fusion sources with new support email address.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-06-12 12:21:58.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-06-13 14:46:35.000000000 -0600
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-06-12 12:21:58.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2007-06-13 14:47:25.000000000 -0600
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptctl.c a/drivers/message/fusion/mptctl.c
--- b/drivers/message/fusion/mptctl.c	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/mptctl.c	2007-06-13 14:46:24.000000000 -0600
@@ -5,7 +5,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptctl.h a/drivers/message/fusion/mptctl.h
--- b/drivers/message/fusion/mptctl.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/mptctl.h	2007-06-13 14:47:14.000000000 -0600
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2007-06-13 14:46:14.000000000 -0600
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptlan.c a/drivers/message/fusion/mptlan.c
--- b/drivers/message/fusion/mptlan.c	2007-06-12 12:21:58.000000000 -0600
+++ a/drivers/message/fusion/mptlan.c	2007-06-13 14:46:03.000000000 -0600
@@ -5,7 +5,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 2000-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptlan.h a/drivers/message/fusion/mptlan.h
--- b/drivers/message/fusion/mptlan.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/mptlan.h	2007-06-13 14:46:58.000000000 -0600
@@ -5,7 +5,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 2000-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-06-13 14:45:53.000000000 -0600
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *  Copyright (c) 2005-2007 Dell
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-06-13 11:47:05.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-06-13 14:45:42.000000000 -0600
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.h	2007-06-13 14:46:47.000000000 -0600
@@ -6,7 +6,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-06-12 12:21:58.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-06-13 14:45:25.000000000 -0600
@@ -4,7 +4,7 @@
  *      running LSI Logic Fusion MPT (Message Passing Technology) firmware.
  *
  *  Copyright (c) 1999-2007 LSI Logic Corporation
- *  (mailto:mpt_linux_developer@lsi.com)
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
  *
  */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
