From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [patch 3/28] Sync up drivers/scsi/aic7xxx
Date: Wed, 29 Sep 2004 08:56:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096441017.2786.12.camel@laptop.fenrus.com>
References: <4159615D.9070604@adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QFFTm9V5sWhJCLGNcdVS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44431 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S268239AbUI2G5B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 02:57:01 -0400
In-Reply-To: <4159615D.9070604@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-QFFTm9V5sWhJCLGNcdVS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-09-28 at 15:04, Luben Tuikov wrote:
> +	/*
> +	 * We perform our own timeout handling.
> +	 */
> +	scsi_delete_timer(cmd);

this surely looks unacceptable as well.


--=-QFFTm9V5sWhJCLGNcdVS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBWly5xULwo51rQBIRAvSzAJwKZJlulUT/UbJsMqjBLxf0OVKGBwCfY6/z
IC3QPRz8rEvZoSWAaKnw6cM=
=Z9Zc
-----END PGP SIGNATURE-----

--=-QFFTm9V5sWhJCLGNcdVS--

