From: Eric Belhomme <rico@ricospirit.net>
Subject: Re: Fw: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work
 with LSI MegaRAID i4 since release 2.00.4
Date: Tue, 13 Feb 2007 22:35:24 +0100
Message-ID: <45D22F1C.7060604@ricospirit.net>
References: <20070213092920.f0bafea0.akpm@linux-foundation.org> <1171389557.3382.34.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hole.ricospirit.net ([82.243.12.45]:47911 "EHLO
	hole.ricospirit.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXBMVoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2007 16:44:15 -0500
In-Reply-To: <1171389557.3382.34.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

James Bottomley a =E9crit :

> This is by design ... the i4 is now supported by the new megaraid_mbo=
x
> driver.  Please retry with that driver.
>=20
Damn ! I spent many hours trying many kernel version, but I never=20
imagined the card support would be translated on megaraid NG !!!

By the way, I added megaraid NG modules on my 2.6.20 and my i4 card is=20
now recognized... But I can't figure how it works :

hole:/home/rico# lsmod|grep megaraid
megaraid_mbox          35368  0
megaraid_mm            12068  1 megaraid_mbox
megaraid               41704  1
scsi_mod              151980  7=20
megaraid_mbox,sr_mod,sd_mod,megaraid,sg,aic7xxx,scsi_transport_spi
ho

So if I understand well, the module actively used with the LSI card is=20
megaraid, the legacy one ! but the mbox and mm are loaded and seems to=20
be necessary for the legacy driver ?

Never mind, sorry for the inconvenience... and the noise on the lkdml !

Regards,

--=20
Rico
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
