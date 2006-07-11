From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 9/9] mptfusion: bump version to 3.04.01
Date: Tue, 11 Jul 2006 17:34:43 -0600
Message-ID: <20060711233443.GD8622@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2003 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932258AbWGKXre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 19:47:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

bump version to 3.04.01

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-07-11 13:08:04.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-07-11 16:39:39.000000000 -0600
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.00"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.00"
+#define MPT_LINUX_VERSION_COMMON	"3.04.01"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.01"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
