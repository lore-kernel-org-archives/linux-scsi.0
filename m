From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 06/06] mptfusion: Bump version 03.04.18
Date: Thu, 3 Feb 2011 15:35:37 +0530
Message-ID: <20110203100528.GG23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47203 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154Ab1BCKv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 05:51:56 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Version upgrade patch. Upgrade version string to 3.4.18

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index f9532fa..2884b41 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.17"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.17"
+#define MPT_LINUX_VERSION_COMMON	"3.04.18"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.18"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
