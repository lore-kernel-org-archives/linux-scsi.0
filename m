From: =?ISO-8859-1?Q?Ren=E9_Rebe?= <rene@rocklinux-consulting.de>
Subject: Re: sym53c8xx_2 regressions in 2.6.9-rc2
Date: Tue, 28 Sep 2004 14:07:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41595406.2080500@rocklinux-consulting.de>
References: <1096316016.1714.77.camel@mulgrave> <20040928013052.GS16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.qsc.de ([213.148.129.14]:5320 "EHLO mx01.qsc.de")
	by vger.kernel.org with ESMTP id S267656AbUI1MJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 08:09:21 -0400
In-Reply-To: <20040928013052.GS16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, valentin@rocklinux-consulting.de

Hi,

Matthew Wilcox wrote:
> On Mon, Sep 27, 2004 at 04:13:26PM -0400, James Bottomley wrote:
>=20
>>Do you have any ideas about this...it doesn't seem to be connected wi=
th
>>domain vaildation.  The errors apparently show up during operation.
>=20
>=20
> Thanks for forwarding this, James.  Rene, it would be useful for you
> to submit bug reports to the maintainer directly, or even contact lin=
ux-scsi.
> I don't have time to wade through the mountains of crap on linux-kern=
el.

And I'm not on any linux-* list, sorry. The next time I will write to=20
linux-scsi directly.

>>On my U30 sparc64 box I get many errors in the system log:
>>
>>Sep 20 15:28:34 sundown kernel: sym0:0:0:phase change 6-7 11@c7ff7b90=
=20
>>resid=3D6.
>>Sep 20 15:28:34 sundown last message repeated 2 times
>>
>>those did not show up in any other 2.6 kernel up to .8.1 ...
>=20
>=20
> When do these show up?  Are they at initialisation time or are they d=
uring
> normal operation?  You report the dmesg from a 2.6.8 kernel, how does=
 the
> 2.6.9-rc2 one differ?  Is the sym2 driver version 2.1.18j in both ker=
nels?

Both, at initialization time _and_ normal operation.

The 2.6.9-rc2 dmesg does list the same devices - but with=20
"sym0:0:0:phase change 6-7 ..." between the devices beeing detected.

I'll rebuild the kernel with the defective scsi driver (I reverted the=20
changes to get a functional system ...) when I'm back in the office in=20
some hours. The 2.6.9-rc2 does contain the domain validation changes, I=
=20
will take a look if the patch in 2.6.9-rc2 does change the version=20
string if this matters.

Have fun,

--=20
Ren=E9 Rebe - Rubensstr. 64 - 12157 Berlin (Europe / Germany)
             +49 (0)30  255 897 45
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
