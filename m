From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/6] mptsas : Bump version to 3.04.12
Date: Wed, 2 Sep 2009 12:44:10 +0530
Message-ID: <20090902071402.GB1592@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:55348 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZIBHga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 03:36:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Bump version to 3.04.12
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index bf446d4..79b17ce 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.11"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.11"
+#define MPT_LINUX_VERSION_COMMON	"3.04.12"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.12"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
