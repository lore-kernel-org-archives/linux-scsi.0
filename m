From: Kurt Garloff <garloff@suse.de>
Subject: Re: 2 PATCHES: fix request_tranferlength
Date: Mon, 22 Jul 2002 03:24:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020722012412.GB10213@nbkurt.etpnet.phys.tue.nl>
References: <20020721151523.D1909@one-eyed-alien.net> <20020721225233.GG7700@linnie.riede.org> <20020721170523.C4018@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020721170523.C4018@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Sun, Jul 21, 2002 at 05:05:23PM -0700, Matthew Dharm wrote:
> We're asking for an odd number of bytes in the command... this just affec=
ts
> the tranfer length field.  It doesn't actually change the command sent.
>=20
> Also, this is the sd.c driver -- SCSI disks.  OnStream _tape_ drives are
> unaffected by this change. :)

Sure. But Willem's remark is valid.

There has been a firmware bug in some old FW for OnStream tapes that made
them go nuts when inquired an odd length on a wide connection.
It's been fixed since long, but it may not be the only one.

According to G=E9rard, you can even expect error messages on a wide bus when
requesting odd numbers of bytes. Though I never agreed with his reasoning.
(IMHO: You should get an ignore wide residual message on reads; on writes y=
ou
 need to send one extra byte which the device should ignore. Neither of whi=
ch
 I consider an error condition. Nor a situation where you have a residual.)

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9O168xmLh6hyYd04RAiQLAKCIHZBwQwfplvTbC09Gf9/OWXnu8gCgr2nS
K1c9J6RpCHJL/EFehPazdmM=
=XnSv
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
