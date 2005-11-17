From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 7/7]  mptfusion - bump version
Date: Wed, 16 Nov 2005 18:54:27 -0700
Message-ID: <200511161854.27351.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TL+eDBpxnRZPHq4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7554 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161095AbVKQB76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 20:59:58 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAH1tHSW011556
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:55:17 -0800 (PST)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id jAH1xwnj001995
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:59:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_TL+eDBpxnRZPHq4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


--Boundary-00=_TL+eDBpxnRZPHq4
Content-Type: text/x-diff;
  charset="us-ascii";
  name="7-bump-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="7-bump-fix.patch"

diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2005-11-16 18:05:52.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2005-11-16 18:20:40.000000000 -0700
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.04"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.04"
+#define MPT_LINUX_VERSION_COMMON	"3.03.05"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.05"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \

--Boundary-00=_TL+eDBpxnRZPHq4--
