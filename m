From: Andre Noll <maan@systemlinux.org>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
Date: Wed, 27 Feb 2008 18:05:28 +0100
Message-ID: <20080227170528.GB29468@skl-net.de>
References: <20080226174314.GA30767@skl-net.de> <47C49B99.1060707@nets.rwth-aachen.de> <20080227101154.GD30767@skl-net.de> <47C57327.6070901@cybernetics.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:43282 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYB0RIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2008 12:08:04 -0500
Content-Disposition: inline
In-Reply-To: <47C57327.6070901@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>, adam radford <aradford@gmail.com>, Johannes =?iso-8859-1?Q?W=F6rner?= <johannes.woerner@tuebingen.mpg.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:26, Tony Battersby wrote:
> > Thanks, this helped a lot. However, there does not seem to be a way
> > to make the system more responsive, which is really the problem we
> > are experiencing.
> >
> > Andre
> >  =20
> This is not 3ware-specific, but kernel 2.6.24 has new per-device write
> throttling that might help with the responsiveness issue:
>=20
> http://kernelnewbies.org/LinuxChanges#head-92340ffcec39e7c2a09fd933243fb1=
8eda57f1b4
> http://lwn.net/Articles/245600/

Yes, but we tried both 2.6.24 and 2.6.25-rc, so Peter's new
write-throttling code doesn't seem to help much in our situtation. I'll
play a bit with the various /proc/sys/vm/* knobs to see if that makes
the system more responsive.

> Also, check to see if the 3ware controller has a background initialize
> or verify in progress, since that will obviously slow things down until
> it is complete.

That's certainly not the case.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHxZhYWto1QDEAkw8RAnlzAKCmNHfQ9RaCVFs7nUbEgVOFSDhWfQCcDRjt
3CZfYIebsu+qQmjf/GCkSDg=
=wI2G
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
