From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Date: Sat, 15 May 2010 14:22:07 +0100
Message-ID: <1273929727.2564.7.camel@localhost>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NodSar6M8FT6VD6xUf5J"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273766206-17402-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-NodSar6M8FT6VD6xUf5J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-05-13 at 17:56 +0200, Tejun Heo wrote:
> Hello, Jens, James, Jeff,
>=20
> This patchset implements ->set_capacity() in libata so that HPA can be
> unlocked on demand.

Thanks Tejun.

>  0001-block-restart-partition-scan-after-resizing-a-device.patch
>  0002-SCSI-implement-sd_set_capacity.patch
>  0003-libata-use-the-enlarged-capacity-after-late-HPA-unlo.patch
>  0004-libata-implement-on-demand-HPA-unlocking.patch
>=20
> 0001 makes partition scan code to restart after ->set_capacity().
> This makes sure that partitions which start beyond the HPA limit are
> discovered.
>=20
> 0002 implements ->set_capacity() in sd.
>=20
> 0003 makes libata accept device capacity larger than the initial one.
>=20
> 0004 implements ->set_capacity() in libata which asks libata EH to
> unlock HPA, waits and returns the new capacity.
>=20
> Ben Hutchings suggeseted implementing ->set_capacity() in libata and
> also reported the bug in the current partition scan code where it
> fails to discover partitions which start beyond the HPA limit.
[...]

And I've already successfully tested the combination of patches 2-4.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-NodSar6M8FT6VD6xUf5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS+6f/ue/yOyVhhEJAQJ+2A//R/QGoxDps1lDtY3MI9MDOOKAbNN3h43k
k5hpZYXYxQQ9eZpqv/it5nH4a9XqZl079i7xvBD2/h5V0AA6QootwHOATNY7xI8p
lEQGtdqmYT2ufaszwgWpfBF8Ehs28EgqIZ2lPXClh9u8UM3L/2bob3cJ0d0NAtZF
vdnpq4WcsYk9RDKtlT9gnAS7e0jlKpU29h2X2K5rARv91NHAE/8VYK1ClvKH9Yhf
jqxaUZ1eV7GwcVSLSuMEkKltlTanEkk7Jk9ZikcFQIJqUIVz6hvoZGUTxEL2c4ub
OKoq9bfKdE3Zsw1bgm5FikUO4k8yR+L2wKjCe56s2pB6ZpBYXzg/NAhsCZ3iczBG
TyAMCqhicReJwqRBdE24KOn347cVsdOG0CQhYNANrV9ACBjIOpJK0Pjm6Xkdvds5
+dn336jobvpRa1UjQssoQb0SV1xhQOwAXq2GW7aVkK2vmzCq8pWHvoq1XV1PJwNl
JgMyyGKZ+BgEMjxrOEgduS2gI6YyqraA/DjUGg4RbIyW6LyKLa4MfTPyAXp0/vUf
+oF7ocbIp1ETci0RwnfxQV1/JAoZ1tkeEIwUFPMg9CdxiDDCoerSKCZy8S0WxlMT
ABYCRBGvoNPQ/VLRlUs/HA670nOJxBnrfdfb7lAHZ7JZ+pmpxphGpPKoHsxB7T0G
UxZdrROpthU=
=cjj8
-----END PGP SIGNATURE-----

--=-NodSar6M8FT6VD6xUf5J--
