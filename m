From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] sd varyio fix
Date: Sun, 28 Jul 2002 21:26:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020728192629.GA11788@nbkurt.etpnet.phys.tue.nl>
References: <20020715221604.GA10274@nbkurt.etpnet.phys.tue.nl> <20020728192845.A15209@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020728192845.A15209@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Linux SCSI list <linux-scsi@vger.kernel.org>, Dave Jones <davej@suse.de>, Andrea Arcangeli <andrea@suse.de>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Sun, Jul 28, 2002 at 07:28:45PM +0100, Christoph Hellwig wrote:
> On Tue, Jul 16, 2002 at 12:16:04AM +0200, Kurt Garloff wrote:
> > Patch against 2.4.19rc1 attached.
>=20
> This patch is not against 2.4.19rc1..  (I guess some SuSE tree?)

That's true. It was some SuSE tree that I used for testing (rc1aaX based).
Just looked at 2.4.19-rc2. And saw that it does not have the varyio stuff.
I thought we did not have any patch there. I should have tested!
Sorry for the noise!

The varyio stuff comes from 10_rawio-vary-io from aa's patches.

I guess I should regenerate the other patches against a clean rc3 ...

Andrea (taken into Cc:): The bitshift in the sd_finish() for the varyio is
the wrong direction.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9REVkxmLh6hyYd04RAmGBAJ4gubcbZtfcA1BLqNZcgs2e3P6rrACaAqM0
84W4IGiKuhPgWgrQyrlodLU=
=L4Qp
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
