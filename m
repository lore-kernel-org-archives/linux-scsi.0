From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 11:22:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424112200.A10511@one-eyed-alien.net>
References: <UTC200304240908.h3O98Cw29064.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:39432 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263709AbTDXSKB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 14:10:01 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304240908.h3O98Cw29064.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Thu, Apr 24, 2003 at 11:08:12AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 11:08:12AM +0200, Andries.Brouwer@cwi.nl wrote:
>     From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
>=20
>     > Comments?
>=20
>     My only comment is that your sample of failed cases primarily seems to
>     address those devices that support some variant of MODE_SENSE -- ther=
e are
>     lots of devices that don't support it at all, which is why I wanted to
>     filter it with the (apparently) now-dead command filter concept.
>=20
> Well, before we create a new infrastructure it is a good idea
> to make sure that it is needed. James mentioned three cases
> in Bugzilla and it looks like these are fixed by a small correction
> to the MODE_SENSE to MODE_SENSE_10 translation.
>=20
> You mention lots of devices that don't support MODE_SENSE at all.
> Do you have Bugzilla or l-k / l-s / l-u refs?

Unfortunately, my data comes from (a) working with this junk for several
years, and (b) non-public conversations with hardware vendors.  While there
linux-usb-devel/users references, you'll have to google for logs to find
them.

Yeah, I know that's a lousy answer.  But try to realize that I've been
dealing with a long, slow, and painful discovery process of what the
'popular OS' uses.

> (Smart Media and similar cards come with a write protect bit.
> I would suppose reporting it is supported by most non-broken hardware.
> We get it from the header of the MODE_SENSE return value.
> So there is some reason to expect that MODE_SENSE[_10] is supported,
> at least in the minimum form where no page but only the header
> is returned. Closer investigation of other error cases might reveal
> more usb-storage flaws.)

This is actually interesting... smart media readers seem to be some of the
worst offenders in terms of not supporting this command (or at least a
variant of it that I've been able to discover).

Hardware vendors tell me that those which build devices based on older
designs (i.e. real SCSI or ATAPI) do support some version of a modesense
because it carried over from their older designs.  Those which are doing
new designs from the ground up do not support it, as apparently neither
Windows nor MacOS check for write-protect this way.  Or so I'm told by the
people who design these things.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Ye gods! I have feet??!
					-- Dust Puppy
User Friendly, 12/4/1997

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qCtHIjReC7bSPZARAg6QAJ9lrK8K9aWLS/CZJ0h9PzMIhvqswQCfRch4
WSNvof62bllvW1lAyXX2YQk=
=7dHu
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
