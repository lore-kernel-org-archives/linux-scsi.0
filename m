From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 1/6] mpt fusion: Driver version upgrade to 3.04.07
Date: Wed, 21 May 2008 00:55:33 +0530
Message-ID: <20080520192532.GB11542@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42377 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926AbYETTeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 15:34:10 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m4KJUPns019618
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 12:30:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com


Updating driver version to 3.04.07 from 3.04.06

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index a8f6174..62ace8d 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2007 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.06"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.06"
+#define MPT_LINUX_VERSION_COMMON	"3.04.07"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.07"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
