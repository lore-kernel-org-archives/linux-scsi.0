From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH] 2.6.2-bk1 - MPT Fusion driver 3.00.03 update
Date: Thu, 5 Feb 2004 18:45:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703D1A630@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:8388 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267084AbUBEXpW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 18:45:22 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

Here is a fix for discarded symbol in mptscsih.c, as
seen in ia64.


You can download full source and 3.00.03 patches here:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/3.00.03


Eric Moore
Standard Storage Products Division
LSI Logic Corporation


diff -uarN linux-2.6.2-bk1-reference/drivers/message/fusion/mptbase.h
linux-2.6.2-bk1/drivers/message/fusion/mptbase.h
--- linux-2.6.2-bk1-reference/drivers/message/fusion/mptbase.h	2004-02-05
16:25:01.878794072 -0700
+++ linux-2.6.2-bk1/drivers/message/fusion/mptbase.h	2004-02-05
16:26:49.514430968 -0700
@@ -80,8 +80,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.00.02"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.00.02"
+#define MPT_LINUX_VERSION_COMMON	"3.00.03"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.00.03"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
diff -uarN linux-2.6.2-bk1-reference/drivers/message/fusion/mptscsih.c
linux-2.6.2-bk1/drivers/message/fusion/mptscsih.c
--- linux-2.6.2-bk1-reference/drivers/message/fusion/mptscsih.c	2004-02-05
16:25:01.889792400 -0700
+++ linux-2.6.2-bk1/drivers/message/fusion/mptscsih.c	2004-02-05
16:26:32.231058440 -0700
@@ -1973,7 +1973,6 @@
 	if (mpt_scsi_hosts > 0)
 		return 0;
 
-	mptscsih_exit();
 	return -ENODEV;
 
 }


