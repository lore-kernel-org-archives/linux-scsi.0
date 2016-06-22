From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: parisc late boot crash in 4.4-rc, scsi-related
Date: Wed, 22 Jun 2016 20:13:58 +0200
Message-ID: <2098261.XbUFfohXuY@caliban.sf-tec.de>
References: <alpine.LRH.2.20.1601082329270.23187@math.ut.ee> <9d1ae51e-69c3-c3f6-60aa-e5238dd18241@bell.net> <alpine.LRH.2.20.1606221451310.11869@math.ut.ee>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5252921.WypFZYtxpW"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([78.47.74.12]:51794 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbcFVSUy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 14:20:54 -0400
In-Reply-To: <alpine.LRH.2.20.1606221451310.11869@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, linux-parisc@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

--nextPart5252921.WypFZYtxpW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Mittwoch, 22. Juni 2016, 14:52:40 schrieb Meelis Roos:
> > > > > I noticed on RP3440 and A500 that recent 4.4-rc* crashes on boot.
> > > > >
> > > > >I've not seen it with 4.4-rc yet, but I've seen it on debian kernel
> > > 
> > > > >4.3.3:
> > > This is still present in 4.6, just tested. All my pariscs are broken
> > > - A500, RP3410, RP3440. 4.3 is the latest working release for me. If
> > > 4.3.3 is broken, it might be possible to bisect more easily.
> > 
> > I believe this is fixed in current gcc versions (4.9 and latter). It was
> > exposed by a blk-merge
> 
> > change.  It was fixed by this change:
> Out of interest, how do other parisc users get the new compiler?
> 
> What distro are you using?
> 
> My pariscs are gentoo and still only the old versions are available on
> hppa.

Several newer versions (4.9, 5.3) are in portage, maybe they just need to be 
unmasked.

Greetings,

Eike
--nextPart5252921.WypFZYtxpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAldq1XAACgkQXKSJPmm5/E7DogCgnIJGAm85X3iNH01Uc0XwUTjE
yJcAn2WMcjjh5TnLKX5KviP8TPaujRCW
=miW1
-----END PGP SIGNATURE-----

--nextPart5252921.WypFZYtxpW--

