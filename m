From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 2/5] fusion-kconfig-cleanup
Date: Wed, 11 May 2005 11:37:29 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0247DC9D@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C55650.1AB55130"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23527 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262006AbVEKRhp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 13:37:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C55650.1AB55130
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 2/5:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.02/

Changelog:
* This patch clarifies help section in FUSION_MAX_SGE entry.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>








------_=_NextPart_000_01C55650.1AB55130
Content-Type: application/octet-stream;
	name="kconfig-2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kconfig-2.patch"

--- b/drivers/message/fusion/Kconfig	2005-05-05 10:19:45.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/Kconfig	2005-05-10 15:01:27.000000000 =
-0600=0A=
@@ -36,17 +36,16 @@=0A=
 	  LSIFC929XL=0A=
 =0A=
 config FUSION_MAX_SGE=0A=
-	int "Maximum number of scatter gather entries"=0A=
-	depends on FUSION_SPI || FUSION_FC=0A=
+	int "Maximum number of scatter gather entries (16 - 128)"=0A=
+	depends on FUSION=0A=
 	default "128"=0A=
+	range 16 128=0A=
 	help=0A=
 	  This option allows you to specify the maximum number of scatter-=0A=
-	  gather entries per I/O. The driver defaults to 40, a reasonable =
number=0A=
-	  for most systems. However, the user may increase this up to 128.=0A=
-	  Increasing this parameter will require significantly more memory=0A=
-	  on a per controller instance. Increasing the parameter is not=0A=
-	  necessary (or recommended) unless the user will be running=0A=
-	  large I/O's via the raw interface.=0A=
+	  gather entries per I/O. The driver default is 128, which matches=0A=
+	  SCSI_MAX_PHYS_SEGMENTS. However, it may decreased down to 16.=0A=
+	  Decreasing this parameter will reduce memory requirements=0A=
+	  on a per controller instance.=0A=
 =0A=
 config FUSION_CTL=0A=
 	tristate "Fusion MPT misc device (ioctl) driver"=0A=

------_=_NextPart_000_01C55650.1AB55130--
