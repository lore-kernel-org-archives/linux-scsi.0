From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Sat, 03 Jan 2004 10:01:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073120514.4429.0.camel@laptop.fenrus.com>
References: <1073076654.2048.19.camel@opiate>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CaEaVdPF5DgGuU2NE9NN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:32384 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S262792AbUACJCC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jan 2004 04:02:02 -0500
In-Reply-To: <1073076654.2048.19.camel@opiate>
List-Id: linux-scsi@vger.kernel.org
To: Eric Kerin <eric@bootseg.com>
Cc: linux-scsi@vger.kernel.org


--=-CaEaVdPF5DgGuU2NE9NN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-01-02 at 21:50, Eric Kerin wrote:
> Loading the aic7xxx or aic79xx modules, on a machine that did not
> contain the card, left a stale entry in the pci_device list.  This
> caused an oops upon loading the next module that registered a
> pci_device.=20
>=20
> The patches below will unregister the pci_device if it successfully
> registers the device, but does not find any cards.=20
>=20
> Comments are appreciated.

well in 2.6 modules are supposed to remain loaded even though no device
is found (since one can be hotplugged later) so that part of the driver
needs changing; other than that yes the driver needs to deregister
itself....

--=-CaEaVdPF5DgGuU2NE9NN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/9oUBxULwo51rQBIRAjAHAJ9oeDoqhOJow7s2mTujD51mQcAYIgCdFsJs
FN6KQkCsGyC88s+ohlfK7nI=
=fJd2
-----END PGP SIGNATURE-----

--=-CaEaVdPF5DgGuU2NE9NN--
