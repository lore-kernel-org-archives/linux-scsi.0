From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 08:56:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077868581.4443.0.camel@laptop.fenrus.com>
References: <1077842444.2662.123.camel@mulgrave>
	 <20040227005601.GA6127@one-eyed-alien.net>
	 <20040227010411.GB819@phunnypharm.org>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YGUG4+2A23rSiRicN53c"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:33152 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S261730AbUB0H4l
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 02:56:41 -0500
In-Reply-To: <20040227010411.GB819@phunnypharm.org>
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-YGUG4+2A23rSiRicN53c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-02-27 at 02:04, Ben Collins wrote:
> On Thu, Feb 26, 2004 at 04:56:01PM -0800, Matthew Dharm wrote:
> > My only concern with something like this is the userspace race problem.
> > i.e the following sequence of events:
> >=20
> > (1) User uses cdrecord -scanbus to locate their device (host:bus:dev:lu=
n)
> > (2) HBA is disconnected=20
> > (3) New HBA is added
> > (4) User issues command to host:bus:dev:lun, and addresses the wrong de=
vice
> >=20
> > While the current system doesn't prevent this, it makes it a much more
> > difficult situation to happen.
>=20
> Surely the user would have to have known that one device was
> disconnected and another connected. Same thing could already be said for
> the scsi device allocation (sda, sdb, and sg0, sg1, sg2, etc...).

surely everyone is using cdrecord -dev=3D/dev/scd5  by now and not the=20
host:bus:dev crap...

--=-YGUG4+2A23rSiRicN53c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAPvglxULwo51rQBIRAuOiAKCCaIVFaYZOOysOu62leGBDedcMBACgk13s
XLo2a987nFHHQCrhLdQ3N6k=
=HQaE
-----END PGP SIGNATURE-----

--=-YGUG4+2A23rSiRicN53c--
