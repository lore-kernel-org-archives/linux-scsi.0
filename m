From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: remove bogus "emulated" host flag
Date: Mon, 15 Jan 2007 21:49:51 +0100 (CET)
Message-ID: <tkrat.28a9be3ceb85c642@s5r6.in-berlin.de>
References: <tkrat.cd304ed480ae458e@s5r6.in-berlin.de>
 <59ad55d30701151141n72e3e99ey509d859c272b8bda@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52418 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXAOUuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2007 15:50:14 -0500
In-Reply-To: <59ad55d30701151141n72e3e99ey509d859c272b8bda@mail.gmail.com>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On 15 Jan, Kristian H=F8gsberg wrote:
> On 1/14/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> There is no emulation going on here.
> ...
>=20
>> -       .emulated                =3D 1,
>=20
> Not sure what this flag does, but I copied it over to fw-sbp2.c.

There is a single use: Userspace application clients can look up the
value of this flag via the sg driver and can then come to whatever
conclusions.

> If it's bogus,

The flag was "half true" back in the times when sbp2 mangled a lot of
commands and responses to account for command sets behind the back of
the SCSI stack. That's not the case any more.

> I guess we should drop it from fw-sbp2.c too.

Yes. I merely didn't ready a patch because I currently want to
concentrate my SBP-2 related work on sbp2 and push relevant bits over t=
o
fw-sbp2 some time later in one go, as far as you didn't do so already.
(I'll send a parallel fw-sbp2 patch too if something earthshaking comes
along.)
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D ---=3D -=3D=3D=3D=3D
http://arcgraph.de/sr/

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
