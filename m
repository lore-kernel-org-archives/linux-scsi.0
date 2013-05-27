From: Jean Delvare <jdelvare@suse.de>
Subject: MAINTAINERS: Fix tape driver file mappings
Date: Mon, 27 May 2013 09:58:10 +0200
Message-ID: <1369641490.4497.5.camel@chaos.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Willem Riede <osst@riede.org>, Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

The masks for the st and osst tape drivers in MAINTAINERS are too
broad and include unrelated files. Make the file list accurate so that
maintainers of these drivers aren't bothered with unrelated work.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Willem Riede <osst@riede.org>
Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
---
Already sent on:
 * 2013-02-28

 MAINTAINERS |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-3.10-rc3.orig/MAINTAINERS	2013-05-27 08:40:52.698827124 +0200
+++ linux-3.10-rc3/MAINTAINERS	2013-05-27 08:41:24.194555638 +0200
@@ -5923,8 +5923,10 @@ M:	Willem Riede <osst@riede.org>
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
@@ -7064,7 +7066,8 @@ M:	Kai M=C3=A4kisara <Kai.Makisara@kolumbus.
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
