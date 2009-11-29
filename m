From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the osd tree with the scsi tree
Date: Mon, 30 Nov 2009 08:44:00 +1100
Message-ID: <20091130084400.adb3e293.sfr@canb.auug.org.au>
References: <20091127143229.108298c6.sfr@canb.auug.org.au>
	<4B123A82.10104@panasas.com>
	<4B127202.1010900@panasas.com>
	<1259502399.2827.14.camel@mulgrave.site>
	<4B1283C9.1030002@panasas.com>
	<1259508215.2827.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Nov_2009_08_44_00_+1100_+Wsy2iDfX3DCvcaf"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753207AbZK2Vn7@vger.kernel.org>
In-Reply-To: <1259508215.2827.15.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, open-osd <osd-dev@open-osd.org>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Mon__30_Nov_2009_08_44_00_+1100_+Wsy2iDfX3DCvcaf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James, Boaz,

On Sun, 29 Nov 2009 10:23:35 -0500 James Bottomley <James.Bottomley@suse.de=
> wrote:
>
> > [PATCH 1/2] osduld: Use device->release instead of internal kref
> > which replaces:
> > f89b9ee [SCSI] osduld: Use device->release instead of internal kref
> >=20
> > and
> >=20
> > [PATCH 2/2] libosd: osd_dev_info: Unique Identification of an OSD device
> > which replaces:
> > 3b616d4 [SCSI] libosd: osd_dev_info: Unique Identification of an OSD de=
vice
>=20
> OK, replacement should be done in scsi-misc (give an hour or two for
> mirror updates).

Thanks guys.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Nov_2009_08_44_00_+1100_+Wsy2iDfX3DCvcaf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksS6yAACgkQjjKRsyhoI8ztnwCgiyTn1vlei1/ZWGXDqSmV8GVm
r5cAnRlPwtzuKy5gPX7QCmBsYbR31Znz
=5407
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Nov_2009_08_44_00_+1100_+Wsy2iDfX3DCvcaf--
