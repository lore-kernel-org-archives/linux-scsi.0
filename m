From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 3/7] mptfusion: Remove credits and update copyright
Date: Tue, 29 Mar 2005 13:05:09 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01C2B982@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C5349A.9BC9D1B0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23719 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261355AbVC2UFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 15:05:14 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j2TK2NJg001617
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 12:02:23 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j2TK5AWh017406
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 12:05:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C5349A.9BC9D1B0
Content-Type: text/plain;
	charset="iso-8859-1"

Remove credits and update copyright - mptctl.[c,h]

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>



------_=_NextPart_000_01C5349A.9BC9D1B0
Content-Type: application/octet-stream;
	name="patch-3-mptctl"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-3-mptctl"

diff -puN scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptctl.c =
scsi-rc-fixes-2.6/drivers/message/fusion/mptctl.c=0A=
--- scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptctl.c	=
2005-03-29 11:19:00.000000000 -0700=0A=
+++ scsi-rc-fixes-2.6/drivers/message/fusion/mptctl.c	2005-03-28 =
17:06:31.000000000 -0700=0A=
@@ -1,40 +1,12 @@=0A=
 /*=0A=
  *  linux/drivers/message/fusion/mptctl.c=0A=
- *      Fusion MPT misc device (ioctl) driver.=0A=
- *      For use with PCI chip/adapter(s):=0A=
- *          LSIFC9xx/LSI409xx Fibre Channel=0A=
+ *      mpt Ioctl driver.=0A=
+ *      For use with LSI Logic PCI chip/adapters=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
- *=0A=
- *      A special thanks to Pamela Delaney (LSI Logic) for tons of =
work=0A=
- *      and countless enhancements while adding support for the =
1030=0A=
- *      chip family.  Pam has been instrumental in the development =
of=0A=
- *      of the 2.xx.xx series fusion drivers, and her contributions =
are=0A=
- *      far too numerous to hope to list in one place.=0A=
- *=0A=
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      A big THANKS to Eddie C. Dost for fixing the ioctl path=0A=
- *      and most importantly f/w download on sparc64 platform!=0A=
- *      (plus Eddie's other helpful hints and insights)=0A=
- *=0A=
- *      Thanks to Arnaldo Carvalho de Melo for finding and patching=0A=
- *      a potential memory leak in mptctl_do_fw_download(),=0A=
- *      and for some kmalloc insight:-)=0A=
- *=0A=
- *      (see also mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Originally By: Steven J. Ralston, Noah Romer=0A=
- *  (mailto:sjralston1@netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptctl.c,v 1.63 2002/12/03 21:26:33 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
@@ -95,8 +67,8 @@=0A=
 #include <scsi/scsi_host.h>=0A=
 #include <scsi/scsi_tcq.h>=0A=
 =0A=
-#define COPYRIGHT	"Copyright (c) 1999-2004 LSI Logic Corporation"=0A=
-#define MODULEAUTHOR	"Steven J. Ralston, Noah Romer, Pamela =
Delaney"=0A=
+#define COPYRIGHT	"Copyright (c) 1999-2005 LSI Logic Corporation"=0A=
+#define MODULEAUTHOR	"LSI Logic Corporation"=0A=
 #include "mptbase.h"=0A=
 #include "mptctl.h"=0A=
 =0A=
diff -puN scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptctl.h =
scsi-rc-fixes-2.6/drivers/message/fusion/mptctl.h=0A=
--- scsi-rc-fixes-2.6/drivers/message/fusion-3.01.20/mptctl.h	=
2005-03-29 11:19:00.000000000 -0700=0A=
+++ scsi-rc-fixes-2.6/drivers/message/fusion/mptctl.h	2005-03-28 =
16:16:29.000000000 -0700=0A=
@@ -5,22 +5,9 @@=0A=
  *          LSIFC9xx/LSI409xx Fibre Channel=0A=
  *      running LSI Logic Fusion MPT (Message Passing Technology) =
firmware.=0A=
  *=0A=
- *  Credits:=0A=
- *      This driver would not exist if not for Alan Cox's =
development=0A=
- *      of the linux i2o driver.=0A=
- *=0A=
- *      A huge debt of gratitude is owed to David S. Miller (DaveM)=0A=
- *      for fixing much of the stupid and broken stuff in the early=0A=
- *      driver while porting to sparc64 platform.  THANK YOU!=0A=
- *=0A=
- *      (see also mptbase.c)=0A=
- *=0A=
- *  Copyright (c) 1999-2004 LSI Logic Corporation=0A=
- *  Originally By: Steven J. Ralston=0A=
- *  (mailto:sjralston1@netscape.net)=0A=
+ *  Copyright (c) 1999-2005 LSI Logic Corporation=0A=
  *  (mailto:mpt_linux_developer@lsil.com)=0A=
  *=0A=
- *  $Id: mptctl.h,v 1.13 2002/12/03 21:26:33 pdelaney Exp $=0A=
  */=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
 =0A=

------_=_NextPart_000_01C5349A.9BC9D1B0--
