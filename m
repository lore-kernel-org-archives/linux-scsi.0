From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 03/03] mptfusion: Bump version 03.04.17
Date: Mon, 26 Jul 2010 18:58:44 +0530
Message-ID: <20100726132832.GD23066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:50971 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154Ab0GZOGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 10:06:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Version upgrade patch.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 0b23c42..23ed3de 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.16"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.16"
+#define MPT_LINUX_VERSION_COMMON	"3.04.17"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.17"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
