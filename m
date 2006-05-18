From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 6/6] mpt fusion - change driver revision to 3.03.10
Date: Thu, 18 May 2006 15:00:46 -0500
Message-ID: <446CD26E.8020109@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020701050209090501030604"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:65465 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751395AbWERUAs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 16:00:48 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k4IMIYAk010649
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 15:18:34 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k4IK0k4126253867
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 13:00:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020701050209090501030604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Bump driver version number to reflect addition of various
fibre channel patches.

Signed-off-by: Michael Reed <mdr@sgi.com>




--------------020701050209090501030604
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

--------------020701050209090501030604--
