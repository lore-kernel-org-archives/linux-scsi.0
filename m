From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 5/6] fusion: bump version
Date: Thu, 4 Jan 2007 20:49:03 -0700
Message-ID: <20070105034903.GA14155@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43968 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030318AbXAEDrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 22:47:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

bump version

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-12-25 01:41:05.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2006-12-25 01:45:41.000000000 -0700
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.02"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.02"
+#define MPT_LINUX_VERSION_COMMON	"3.04.03"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.03"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
