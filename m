From: Olaf Hering <olh@suse.de>
Subject: Re: [announce] scsi_id release 0.2
Date: Sun, 7 Dec 2003 16:38:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031207153802.GA6700@suse.de>
References: <20031205151810.A8891@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:44949 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264437AbTLGPiE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2003 10:38:04 -0500
Content-Disposition: inline
In-Reply-To: <20031205151810.A8891@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

 On Fri, Dec 05, Patrick Mansfield wrote:

> Version 0.2 of scsi_id is available at:
>=20
> http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.2.tar.gz

What is $(DEBUG)? It is used by klibc and replaced by true/false.

diff -purN scsi_id-0.2/Makefile extras/scsi_id/Makefile
--- scsi_id-0.2/Makefile        2003-12-05 23:26:25.000000000 +0100
+++ extras/scsi_id/Makefile     2003-12-07 16:08:20.000000000 +0100
@@ -27,7 +27,7 @@ INSTALL_DATA  =3D ${INSTALL} -m 644
 # Note some of the variables used here are set when built under udev, =
and
 # otherwise might not be set.
=20
-override CFLAGS+=3D-DSCSI_ID_VERSION=3D\"$(SCSI_ID_VERSION)\" $(DEBUG)=
 -Wall
+override CFLAGS+=3D-DSCSI_ID_VERSION=3D\"$(SCSI_ID_VERSION)\" -Wall
=20
 PROG=3Dscsi_id
 SYSFS=3D-lsysfs



--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
