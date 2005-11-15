From: Ingo Juergensmann <ij@2005.bluespice.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 15 Nov 2005 11:17:09 +0100
Message-ID: <20051115101709.GK7031@2004.bluespice.org>
References: <200510051314.33411.ak@suse.de> <20051005113108.GA19437@parisc-linux.org> <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain> <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwbb4r/vLufKlfJs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from windfluechter.net ([217.160.213.221]:31751 "EHLO
	windfluechter.net") by vger.kernel.org with ESMTP id S932341AbVKOKRm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 05:17:42 -0500
Content-Disposition: inline
In-Reply-To: <20051115095152.GA23470@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>


--rwbb4r/vLufKlfJs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2005 at 09:51:52AM +0000, Christoph Hellwig wrote:
> On Fri, Oct 07, 2005 at 03:53:52PM +0200, Kars de Jong wrote:
> > > > It was rejected upstream because patches for the 53c7xx driver are =
no longer
> > > > accepted. we should use the 53c700 core instead.
> > > Yep; I'll find time later this month to look at switching to use 53c7=
00.
> > I already did that, including the modifications needed to use the iomap
> > interface on m68k. I'll hopefully get around to testing it on an MVME167
> > this weekend.
> Did you make any progress on this?=20

I guess he made... Kars gave me a kernel image for Amiga:

53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
scsi0: 53c710 rev 2
53c700: dmode=3D80 dcntl=3D01 ctest7=3D02
scsi0 : WarpEngine 40xx

spice:/home/ij# uptime
 11:13:14 up 4 days, 14:59,  3 users,  load average: 0.02, 0.20, 0.13

So far, I haven't experienced any problems with that new driver. I intend to
try that kernel on an Amiga 4000T with its implementation of that chip
(A4091-alike)...

--=20
Ciao...                //        Fon: 0381-2744150=20
      Ingo           \X/         SIP: 2744150@sipgate.de

gpg pubkey: http://www.juergensmann.de/ij/public_key.asc

--rwbb4r/vLufKlfJs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDebWllCnCZmI+zY0RArBEAJ97fykA0IwHt2R20FrSlQ8iGFH7pgCfalW4
ylLg0wotadwax8pQ0h2aq7k=
=tfFv
-----END PGP SIGNATURE-----

--rwbb4r/vLufKlfJs--
