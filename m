From: <Patrick_Boyd@Dell.com>
Subject: RE: [PATCH 5/6] fusion: bump version
Date: Fri, 5 Jan 2007 10:37:12 -0600
Message-ID: <FCD01C3AA0ADFB498F9BB1A6173DFC5DE5AD72@ausx3mpc120.aus.amer.dell.com>
References: <20070105034903.GA14155@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:10047 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161146AbXAEQqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2007 11:46:51 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20070105034903.GA14155@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eric.moore@lsil.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Is there a reason that you have the version information in two different
places instead of just concatinating the strings together?

Patrick Boyd
Dell Storage Software Engineer
(512)728-3182
 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Eric Moore
Sent: Thursday, January 04, 2007 9:49 PM
To: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com
Subject: [PATCH 5/6] fusion: bump version

bump version

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.h
a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-12-25 01:41:05.000000000
-0700
+++ a/drivers/message/fusion/mptbase.h	2006-12-25 01:45:41.000000000
-0700
@@ -75,8 +75,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.02"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.02"
+#define MPT_LINUX_VERSION_COMMON	"3.04.03"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.03"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
