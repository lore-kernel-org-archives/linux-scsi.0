From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/2] mptsas : Bump version to 3.04.13
Date: Wed, 7 Oct 2009 11:28:50 +0530
Message-ID: <20091007055844.GD24815@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57364 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482AbZJGGX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2009 02:23:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Bump version 3.04.13.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 8dd4d21..b494867 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.12"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.12"
+#define MPT_LINUX_VERSION_COMMON	"3.04.13"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.13"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
