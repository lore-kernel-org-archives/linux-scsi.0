From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 0/3] PS3 Storage Drivers for 2.6.23, take 5
Date: Mon, 16 Jul 2007 18:15:39 +0200
Message-ID: <20070716161539.075822000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43535 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755422AbXGPQW4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 12:22:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

	Hi,

These are the remaining patches of the new PS3 storage drivers series:
  [1] ps3: Disk Storage Driver
  [2] ps3: BD/DVD/CD-ROM Storage Driver
  [3] ps3: FLASH ROM Storage Driver

They are based on:
  - the current Linux kernel source tree,
  - plus the PS3 patches already submitted by Geoff Levand on linuxppc-=
dev,
    which are in the for-2.6.23 branch of Paulus' tree,
  - plus the first 3 patches from the PS3 storage drivers series I subm=
itted
    before, which are also in the for-2.6.23 branch of Paulus' tree.

The only changes compared to the previous submission are the kmap updat=
es, as
requested by Jens Axboe and James E.J. Bottomley.

I didn't hear anything from the misc device maintainer (for the FLASH R=
OM
Storage Driver).

Paulus, please apply.  Thanks in advance!

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
