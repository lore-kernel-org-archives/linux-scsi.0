From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/6] mpt fusion: remove unused header - linux_compat.h
Date: Wed, 13 Jun 2007 16:33:48 -0600
Message-ID: <20070613223347.GA21141@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35643 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbXFMWiC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:38:02 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, DL-MPTFusionLinux@lsi.com

remove unused header

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/linux_compat.h a/drivers/message/fusion/linux_compat.h
--- b/drivers/message/fusion/linux_compat.h	2007-04-25 21:08:32.000000000 -0600
+++ a/drivers/message/fusion/linux_compat.h	1969-12-31 17:00:00.000000000 -0700
@@ -1,9 +0,0 @@
-/* drivers/message/fusion/linux_compat.h */
-
-#ifndef FUSION_LINUX_COMPAT_H
-#define FUSION_LINUX_COMPAT_H
-
-#include <linux/version.h>
-#include <scsi/scsi_device.h>
-
-#endif /* _LINUX_COMPAT_H */
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-06-13 14:46:14.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2007-06-13 15:36:48.000000000 -0600
@@ -43,7 +43,6 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-#include "linux_compat.h"	/* linux-2.6 tweaks */
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-06-13 14:45:42.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-06-13 15:37:26.000000000 -0600
@@ -44,7 +44,6 @@
 */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
-#include "linux_compat.h"	/* linux-2.6 tweaks */
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-06-13 14:45:25.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-06-13 15:37:47.000000000 -0600
@@ -44,7 +44,6 @@
 */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
-#include "linux_compat.h"	/* linux-2.6 tweaks */
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
