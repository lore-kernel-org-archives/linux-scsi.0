From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] MAINTAINERS: Fix tape driver file mappings
Date: Thu, 28 Feb 2013 13:51:51 +0100
Message-ID: <1362055911.4369.6.camel@amber.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab3B1Mvo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2013 07:51:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Willem Riede <osst@riede.org>, Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@parallels.com>

The masks for the st and osst tape drivers in MAINTAINERS are too
broad and include unrelated files. Make the file list accurate so that
maintainers of these drivers aren't bothered with unrelated work.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Willem Riede <osst@riede.org>
Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
---
 MAINTAINERS |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-3.9-rc0.orig/MAINTAINERS	2013-02-28 09:47:34.124905652 +0100
+++ linux-3.9-rc0/MAINTAINERS	2013-02-28 13:35:08.859450011 +0100
@@ -5779,8 +5779,10 @@
 L:	osst-users@lists.sourceforge.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	drivers/scsi/osst*
-F:	drivers/scsi/st*
+F:	Documentation/scsi/osst.txt
+F:	drivers/scsi/osst.*
+F:	drivers/scsi/osst_*.h
+F:	drivers/scsi/st.h
=20
 OPENCORES I2C BUS DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
@@ -6898,7 +6900,8 @@
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/st.txt
-F:	drivers/scsi/st*
+F:	drivers/scsi/st.*
+F:	drivers/scsi/st_*.h
=20
 SCTP PROTOCOL
 M:	Vlad Yasevich <vyasevich@gmail.com>

--=20
Jean Delvare
Suse L3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
