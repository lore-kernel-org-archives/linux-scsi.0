From: Kurt Garloff <garloff@suse.de>
Subject: Re: 2 PATCHES: fix request_tranferlength
Date: Mon, 29 Jul 2002 18:50:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729165049.GJ21443@nbkurt.etpnet.phys.tue.nl>
References: <1027955906.842.38.camel@irongate.swansea.linux.org.uk> <Pine.LNX.4.33L2.0207290859540.23252-100000@dragon.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QxN5xOWGsmh5a4wb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33L2.0207290859540.23252-100000@dragon.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--QxN5xOWGsmh5a4wb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2002 at 09:00:21AM -0700, Randy.Dunlap wrote:
> On 29 Jul 2002, Alan Cox wrote:
>=20
> | On Sat, 2002-07-27 at 23:07, Matthew Dharm wrote:
> | > >  	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
> | > > -		      512, SD_TIMEOUT, MAX_RETRIES);
> | > > +		      255, SD_TIMEOUT, MAX_RETRIES);
> |
> | Adjust it and the buffer size to be even and I'll test run it in -ac
>=20
> One of the earlier emails quoted a 252 max. size from a newer spec.

252 is also what I used in my sd-many patches
http://www.suse.de/~garloff/scsi-many/

It does not incur a IGNORE_WIDE_RESIDUAL even on wide32 buses. Probably
that's why this size was specified for some transfers.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--QxN5xOWGsmh5a4wb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9RXJpxmLh6hyYd04RAoV0AKDGdDZqaMNeo/zRnl7f220PuRcTqgCgnG7E
ARi2iRMZedtWZwk9AL5K2jc=
=/GBc
-----END PGP SIGNATURE-----

--QxN5xOWGsmh5a4wb--
