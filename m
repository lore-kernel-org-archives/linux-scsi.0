From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [RFC] add transfer request length?
Date: Thu, 30 May 2002 09:30:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020530093035.A32763@one-eyed-alien.net>
References: <20020529230047.D26782@one-eyed-alien.net> <20020530105857.GI12126@linnie.riede.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020530105857.GI12126@linnie.riede.org>; from wrlk@riede.org on Thu, May 30, 2002 at 06:58:57AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2002 at 06:58:57AM -0400, Willem Riede wrote:
> /*
>  * Function:    scsi_do_req
>  *
>  * Purpose:     Queue a SCSI request
>  *
>  * Arguments:   SRpnt     - command descriptor.
>  *              cmnd      - actual SCSI command to be performed.
>  *              buffer    - data buffer.
>  *              bufflen   - size of data buffer.
>  *              done      - completion function to be run.
>  *              timeout   - how long to let it run before timeout.
>  *              retries   - number of retries we allow.
>=20
> The bufflen above is not enough?
>=20
> Thanks, Willem Riede.

No, because we still get commands that really expect to transfer less than
a bufflen.  Osst was the worst offender, but there are others.  Start
playing with dd for a while with small block sizes and you can see some
strange effects.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What the hell are you?
					-- Pitr to Dust Puppy=20
User Friendly, 12/3/1997

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE89lOqIjReC7bSPZARAupbAKCirxRMCDvDfPNhE4asjWCK3OoJFwCfSDuy
z6QYB9Y4qNOsr3XkyhbYjeI=
=Ga79
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
