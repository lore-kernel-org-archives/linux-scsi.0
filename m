From: Eduard Bloch <edi@gmx.de>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Fri, 26 Mar 2004 15:55:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040326145506.GA31759@zombie.inka.de>
References: <20040325225423.GT9248@cheney.cx> <MDEHLPKNGKAHNMBLJOLKCEEOLEAA.davids@webmaster.com> <20040326131629.GB26910@zombie.inka.de> <40643BFA.1000302@stesmi.com> <20040326142917.GB30664@zombie.inka.de> <40644071.9090900@stesmi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:15819 "EHLO mail.inka.de")
	by vger.kernel.org with ESMTP id S263144AbUCZOy7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 09:54:59 -0500
Content-Disposition: inline
In-Reply-To: <40644071.9090900@stesmi.com>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: David Schwartz <davids@webmaster.com>, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

#include <hallo.h>
* Stefan Smietanowski [Fri, Mar 26 2004, 03:38:41PM]:

> >The GPL does not talk about the code to create things, but code to
> >_modify_ things. If you never have to modify the firmware file, wher=
e is
> >the point?
>=20
> And if I feel like I _want_ to modify it? Then I should be entitled
> to the preferred form to make modifications to it as is my right
> under the GPL, regardless of if I a) want to b) have a need to
> c) give a rat's ass about what the firmware does or does not do.
> A binary blob is extremely seldom the preferred form to make
> modifications to, even though some such cases do or might exist.

Same with WAV and PNG files distributed with many GPL packages. It is
widely accepted method to distribute files that do not need modificatio=
n
without their "source" (whatever source is used to create them).

> You do know that certain TV cards (using the ivtv driver) lack a rom
> and needs a firmware initialized during startup just like this exampl=
e.
>=20
> Why am I taking this up ? Well they have specifically stated that the
> firmware _may not be used without the windows driver_ even though
> others have written a fully working driver that _only_ needs the
> firmware from the windows driver to function under linux.

Write a firmware loader that extracts it from the Windows DLLs. Such
things happened in the past and work AFAIK quite good.

> Surprised? If they put the firmware on the card (rom/flash/eeprom)

No.

> this wouldn't have happened but it did.
> How exactly do you believe this makes anything more flexible for me
> as an end user when it is not LEGAL for me to use the card with
> linux due to the firmware issue.

Imagine, there is a bug in the firmware. Normaly, you would have to boo=
t
windows or DOS to run a flash tool to install it into the device. Here
you just replace the DLL.

> Yes, some claim there IS a loophole in that the end user MAY extract
> the firmware from the windows driver himself and use it together
> with the (open) linux driver but IANAL. Ie use but not redistribute.

The user gets the driver CD when he buys the hardware.

Regards,
Eduard.
--=20
Ein Lehrer, Hausvater =E4rgert sich gerade =FCber die wiederkommenden
=46ehler am meisten, da ers als =FCber in der Natur gegr=FCndete am
wenigsten sollte.
		-- Jean Paul (eig. Johann Paul Friedrich Richter)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
