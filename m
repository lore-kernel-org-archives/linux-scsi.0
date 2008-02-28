From: Andre Noll <maan@systemlinux.org>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Thu, 28 Feb 2008 10:46:08 +0100
Message-ID: <20080228094608.GC29468@skl-net.de>
References: <20080226174314.GA30767@skl-net.de> <47C49B99.1060707@nets.rwth-aachen.de> <20080227101154.GD30767@skl-net.de> <47C57327.6070901@cybernetics.com> <20080227170528.GB29468@skl-net.de> <b1bc6a000802271206l3e99afedt64d5f7cc238365d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:59552 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYB1JsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2008 04:48:06 -0500
Content-Disposition: inline
In-Reply-To: <b1bc6a000802271206l3e99afedt64d5f7cc238365d6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, Arnd Hannemann <hannemann@nets.rwth-aachen.de>, Johannes =?iso-8859-1?Q?W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:06, adam radford wrote:
> On Wed, Feb 27, 2008 at 9:05 AM, Andre Noll <maan@systemlinux.org> wrote:
> > On 09:26, Tony Battersby wrote:
> >  > > Thanks, this helped a lot. However, there does not seem to be a way
> >  > > to make the system more responsive, which is really the problem we
> >  > > are experiencing.
>=20
> Can you try turning down /sys/block/sdX/device/queue_depth to 16 and
> see if that improves your responsiveness?

Yes, that setting seems to improve responsiveness greatly.

Thanks a lot
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHxoLgWto1QDEAkw8RAvHdAKCQwfc48LLFiHfgeq5ixDN9JIE/6ACffEz8
7IbmjoookCU7sNuLsc1G1Bw=
=/oiv
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
