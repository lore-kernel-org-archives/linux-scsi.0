From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Patch for iriver-mp3player
Date: Sun, 6 Jun 2004 15:32:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606223250.GA15574@one-eyed-alien.net>
References: <20040530014255.3876eea3.little.tobias@gmx.de> <1086533333.10787.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:65421 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264192AbUFFWdB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jun 2004 18:33:01 -0400
Content-Disposition: inline
In-Reply-To: <1086533333.10787.45.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tobias Lieber <little.tobias@gmx.de>, Alan Stern <stern@rowland.harvard.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 06, 2004 at 09:48:51AM -0500, James Bottomley wrote:
> On Sat, 2004-05-29 at 18:42, Tobias Lieber wrote:
> > i Javier Marcet wrote in January 2004 a patch for linux-2.6.3, to make =
a i-River-mp3-Player mounting. It was on lkml: http://lkml.org/lkml/2004/1/=
6/170
> > i was suprised, that it was not in the kernel, and no other soulution, =
too. So i read his patch for getting mouted the player, and rewrote it for =
linux-2.6.7-rc1-bk7. I attached it. It would be nice, if it would be possib=
le mounting the mp3-player without patching the Kernel, so i would greet it=
, if this or an other solution woulg com into the Kernel.
>=20
> Well, but the question is who gets to fix this?
>=20
> Since this is a USB device returning broken inquiry data which sd then
> acts on, I'd rather see USB fix it.
>=20
> I cc'd the USB people.  Since you already do some scrubbing on the
> inquiry data from this thing (to fix up the ANSI SCSI type), can't you
> just add it as an unusual dev that needs the RMB bit resetting (and, if
> that's so far wrong, probably other vital pieces of inquiry data as
> well)?

We're actually trying to figure out the 'right way' to do this now.  Our
expectation is that there is some algorithmic way to determine if this bit
is "right" or not, as Windows seems to get it right without
white/blacklisting.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We've made a business out of making money from annoying and stupid people.
I think you fall under that category.
					-- Chief
User Friendly, 7/11/1998

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAw5uSIjReC7bSPZARAvgJAJ0ZuOviIlVbVYsC7rx9jLAb1acivgCcDx2T
RJzLJ5RxRqyr9Y9cJEkbH2c=
=nGi8
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
