From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 5/5] fusion - bump driver version to 3.03.02
Date: Wed, 11 May 2005 11:37:43 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0247DCA0@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C55650.234935A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:27367 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262010AbVEKRh5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 13:37:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C55650.234935A0
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 5/5:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.02/

Bump driver version to 3.03.02

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C55650.234935A0
Content-Type: application/octet-stream;
	name="bump_ver-5.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="bump_ver-5.patch"

--- b/drivers/message/fusion/mptbase.h	2005-05-05 10:19:45.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-05-10 15:09:56.000000000 =
-0600=0A=
@@ -76,8 +76,8 @@=0A=
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR=0A=
 #endif=0A=
 =0A=
-#define MPT_LINUX_VERSION_COMMON	"3.03.01"=0A=
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.01"=0A=
+#define MPT_LINUX_VERSION_COMMON	"3.03.02"=0A=
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.02"=0A=
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"=0A=
 =0A=
 #define show_mptmod_ver(s,ver)  \=0A=

------_=_NextPart_000_01C55650.234935A0--
