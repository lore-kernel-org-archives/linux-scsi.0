From: Michael Reed <mdr@sgi.com>
Subject: [REPOST][PATCH 6/6] mpt fusion - change driver revision to 3.03.10
Date: Wed, 24 May 2006 15:08:10 -0500
Message-ID: <4474BD2A.3050007@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010906020607090207050407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:36249 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932230AbWEXUIS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 May 2006 16:08:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

This is a multi-part message in MIME format.
--------------010906020607090207050407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bump driver version number to reflect addition of various
fibre channel patches.

(Unchanged from last posting.)

Signed-off-by: Michael Reed <mdr@sgi.com>





--------------010906020607090207050407
Content-Type: text/x-patch;
 name="06-mptfc_bump_driver_version.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06-mptfc_bump_driver_version.patch"

Bump driver version number to reflect addition of various
fibre channel patches.

Signed-off-by: Michael Reed <mdr@sgi.com>



--- rc3c/drivers/message/fusion/mptbase.h	2006-05-08 15:05:27.972247067 -0500
+++ rc3/drivers/message/fusion/mptbase.h	2006-05-08 15:06:04.490752995 -0500
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.09"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.09"
+#define MPT_LINUX_VERSION_COMMON	"3.03.10"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.10"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \

--------------010906020607090207050407--
