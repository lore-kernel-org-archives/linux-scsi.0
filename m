From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 08:36:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030422083621.B28101@one-eyed-alien.net>
References: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl> <20030421181755.A19118@one-eyed-alien.net> <1051021911.14880.25.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:13836 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263208AbTDVPYW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 11:24:22 -0400
Content-Disposition: inline
In-Reply-To: <1051021911.14880.25.camel@dhcp22.swansea.linux.org.uk>; from alan@lxorguk.ukuu.org.uk on Tue, Apr 22, 2003 at 03:31:52PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andries.Brouwer@cwi.nl, James Bottomley <James.Bottomley@SteelEye.com>, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, Linus Torvalds <torvalds@transmeta.com>, usb-storage@one-eyed-alien.net


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 03:31:52PM +0100, Alan Cox wrote:
> On Maw, 2003-04-22 at 02:17, Matthew Dharm wrote:
> > Your patches went a long way to improving things.  But, then people add=
ed
> > EVPD and further changed MODE_SENSE and other things.   It's pretty cle=
ar
> > to me that trying to change the SCSI core to not use these commands isn=
't
> > going to happen -- so I want a way to filter them.  I originally wanted=
 a
> > centralized filter (i.e. usb-storage could indicate to the mid-layer no=
t to
> > send the 'unwelcome' commands), but that got shot down in favor of a
> > centralized filter-framework which could be applied by any LLDD that wa=
nted
> > to.
>=20
> You already can do this. You just need to write yourself a library
> routine which converts/blocks according to the filter rules (ie
> read6->read10, returns errors to fancy stuff etc).

I thought that the entire point was to have all this in a centralized place
for use by multiple LLDDs (or anyone else for that matter).  Which is the
entire point of this discussion.

If it's not going to be accepted as a centralized filter-framework, then
I'll just add it to the usb-storage driver and leave it at that.  But I'm
pretty certain that we will keep revisiting this issue as we see more and
more development of the SCSI core to support some more unusual commands and
we see more and more emulated-SCSI busses which choke on those commands.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pWF1IjReC7bSPZARAoo2AKDLYB6JfIPLcmvDFmgNAATUXatlwACfRGuH
z+WUogUPS2x5bAJ3RV7Xj44=
=2/7q
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
