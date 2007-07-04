From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 4
Date: Wed, 04 Jul 2007 15:22:12 +0200
Message-ID: <20070704132212.726923000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46148 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759488AbXGDNYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 09:24:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

	Hi,

This is the fourth submission of the new PS3 storage drivers:
  [1] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage dri=
ver
  [2] ps3: Storage Driver Core
  [3] ps3: Storage device registration routines.
  [4] ps3: Disk Storage Driver
  [5] ps3: BD/DVD/CD-ROM Storage Driver
  [6] ps3: FLASH ROM Storage Driver

They are based on:
  - the current Linux kernel source tree,
  - plus the PS3 patches already submitted by Geoff Levand on linuxppc-=
dev,
  - plus the shost_priv() patch in scsi-misc (commit
    bcd92c9fbcc679ee95003083056f0441a1f474fa).

All issues raised during the previous review rounds should be fixed.
There were no more comments after the third submission.

Paul already integrated Geoff Levand's PS3 patches and the first 3 patc=
hes
in this series in the for-2.6.23 branch in powerpc.git.

Maintainers of block/SCSI/misc, can you please ack the last 3 patches s=
o Paul
can take them, too?

Thanks in advance!

With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
=46ax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Be=
lgium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
=46ortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE390013823=
58619

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
