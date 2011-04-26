From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/03] mptfusion: Bump version 3.4.19
Date: Tue, 26 Apr 2011 12:10:08 +0530
Message-ID: <20110426064004.GE6066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57592 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756108Ab1DZGUd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2011 02:20:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Update version string to 3.4.19

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 1735c84..fe90233 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.18"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.18"
+#define MPT_LINUX_VERSION_COMMON	"3.04.19"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.19"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
