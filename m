From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [multipath] SCSI device capacity mess
Date: Tue, 26 Oct 2004 23:46:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098827186.4914.34.camel@zezette>
References: <1098833278.4914.24.camel@zezette>
	 <1098826481.2140.534.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.wanadoo.fr ([193.252.22.27]:6812 "EHLO
	mwinf0408.wanadoo.fr") by vger.kernel.org with ESMTP
	id S261486AbUJZVq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 17:46:29 -0400
In-Reply-To: <1098826481.2140.534.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le mardi 26 octobre 2004 =C3=A0 17:34 -0400, James Bottomley a =C3=A9cr=
it :
> On Tue, 2004-10-26 at 19:27, christophe varoqui wrote:
> > 1) make the /sys/block/*/size attribute writable
> > 2) resurrect a BLKSETSIZE ioctl
> > 3) make device-mapper less strict, and hope we can fix the size by =
a
> > device rescan when it get activated
> > 4) sell the culprit hardware
>=20
> Only 3 & 4 look viable.  There's little point introducing an extra AP=
I
> or ioctl specifically to defeat a check, since the check will now be
> useless anyway.
>=20
:) I feared you would vote for 4)
That is not that viable for me, as you can imagine.

The culprit hardware, should I have reported, is a HSG80 controler pair
configured in multibus mode.

I though you could have considered 1) as it is just another way for roo=
t
to shoot itself and the multipath daemon can apply to detected valid
size on other paths to apply it to ghost paths. That didn't seem so
awkward to me.

I fear Alasdair reaction to 3) will be cold ... I still hope we can com=
e
out with a solution, even one I havn't thought about.

> The "random" value is 1GB by the way.  Since the dawn of time SCSI ha=
s
> reported this for devices that failed read capacity.
>=20
Ah, good to know. Thanks

regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
