From: Eduard Bloch <edi@gmx.de>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Fri, 26 Mar 2004 15:29:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040326142917.GB30664@zombie.inka.de>
References: <20040325225423.GT9248@cheney.cx> <MDEHLPKNGKAHNMBLJOLKCEEOLEAA.davids@webmaster.com> <20040326131629.GB26910@zombie.inka.de> <40643BFA.1000302@stesmi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:32969 "EHLO mail.inka.de")
	by vger.kernel.org with ESMTP id S262796AbUCZO3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 09:29:06 -0500
Content-Disposition: inline
In-Reply-To: <40643BFA.1000302@stesmi.com>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: David Schwartz <davids@webmaster.com>, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

#include <hallo.h>
* Stefan Smietanowski [Fri, Mar 26 2004, 03:19:38PM]:

> >Yes, the driver authors PREFERS to make the changes on the C source
> >code, he never has to modify the firmware. Exactly what the GPL
> >requests, where is your problem?
>=20
> But the firmware didn't appear out of thin air - someone wrote it
> somehow. If that's using a hex editor or inside the C code doesn't

The GPL does not talk about the code to create things, but code to
_modify_ things. If you never have to modify the firmware file, where i=
s
the point?

I do not see a big difference between firmware data stored in a flash
rom inside of the hardware part and the same data loaded during the
driver initialisation. In contrary, it saves money and makes things mor=
e
flexible. You should thank your hardware manufacturer instead of
bitching about bogus things.

Regards,
Eduard.
--=20
Wenn du einen verhungernden Hund aufliest und machst ihn satt, dann
wird er dich nicht bei=DFen. Das ist der Grundunterschied zwischen Hund
und Mensch.
		-- Mark Twain (eigl. Samuel Langhorne Clemens)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
