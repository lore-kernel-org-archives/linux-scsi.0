From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 18:24:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529162437.GF31365@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28366 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265215AbUE2QYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 12:24:45 -0400
Content-Disposition: inline
In-Reply-To: <20040529155744.GA32621@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 29, 2004 at 11:57:44AM -0400, Alan Cox wrote:
> On Sat, May 29, 2004 at 10:55:24AM -0500, James Bottomley wrote:
> > > This is an error. Linus has also vetoed this change. Consider the
> > > Fedora kernel wrong on this point. It isnt however your SG_IO issue I think
> > 
> > I don't necessarily regard this as an error: single attachment of ULDs
> > would be very helpful.  However, since the mechanics of implementing
> 
> Its most definitely problematic - it breaks a ton of existing tools, and

most of the existing tools take a device as argument, it doesn't (shouldn't)
matter if that device name is /dev/sg0 or /dev/sda. After all the ioctls are
the same between sg and SG_IO.

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAuLlExULwo51rQBIRAmBjAKCmJnjMsR3q4MosyI7LAjjHHt88wgCcCTAK
j/KFBmhBo9SGViPech7oQfk=
=vdY4
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
