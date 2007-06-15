From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 2
Date: Fri, 15 Jun 2007 13:39:19 +0200
Message-ID: <20070615113919.142332000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49678 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753835AbXFOMLX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 08:11:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

	Hi,

This is the second submission of the new PS3 storage drivers:
  [1] ps3: Preallocate bootmem memory for the PS3 FLASH ROM storage dri=
ver
  [2] ps3: Storage Driver Core
  [3] ps3: Storage device registration routines.
  [4] ps3: Disk Storage Driver
  [5] ps3: ROM Storage Driver
  [6] ps3: FLASH ROM Storage Driver

They are based on the current Linux kernel source tree, plus the PS3 pa=
tches
already submitted by Geoff Levand on linuxppc-dev.

All issues raised during the previous review round should be fixed.

If there are no more comments, please apply for 2.6.23.  Since they dep=
end on
other PS3 work, I think it's most logical to let Paul integrate them.

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
