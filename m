From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 6/6] mpt fusion: bump version
Date: Wed, 13 Jun 2007 16:35:21 -0600
Message-ID: <20070613223521.GA21211@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35733 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbXFMWjf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:39:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, DL-MPTFusionLinux@lsi.com

bump version

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-06-13 15:36:18.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2007-06-13 15:40:23.000000000 -0600
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.04"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.04"
+#define MPT_LINUX_VERSION_COMMON	"3.04.05"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.05"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
