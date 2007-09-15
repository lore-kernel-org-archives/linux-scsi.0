From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 8/8] mpt fusion: bump version to 3.04.06
Date: Fri, 14 Sep 2007 18:52:28 -0600
Message-ID: <20070915005228.GA16861@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48519 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310AbXIOBAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 21:00:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

bump version

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2007-09-14 17:52:30.000000000 -0600
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.05"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.05"
+#define MPT_LINUX_VERSION_COMMON	"3.04.06"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.06"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
