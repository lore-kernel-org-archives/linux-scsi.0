From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Updated Patch for ServeRAID V7.12.02
Date: Mon, 25 Jul 2005 09:00:45 -0400
Message-ID: <1122296445.3124.0.camel@localhost.localdomain>
References: <A121ABA5B472B74EB59076B8E3C8F0190153437A@rtpe2k01.adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4vjjJCD67lZt1blC0WOA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:6582 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261158AbVGYNA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 09:00:56 -0400
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F0190153437A@rtpe2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: linux-scsi@vger.kernel.org


--=-4vjjJCD67lZt1blC0WOA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2005-07-25 at 08:46 -0400, Hammer, Jack wrote:
> I am resubmitting the 2.6 kernel patch for the Version 7.12.02 ips
> driver.
> I have eliminated a couple of inappropriate changes pointed out by
> Arjan.
>=20
> Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>
>=20
> --- a/drivers/scsi/ips.c	Tue Jul 19 13:15:24 2005
> +++ b/drivers/scsi/ips.c	Tue Jul 19 13:12:44 2005
> @@ -133,10 +133,12 @@
>  /* 6.10.00  - Remove 1G Addressing Limitations
> */
>  /* 6.11.xx  - Get VersionInfo buffer off the stack !              DDTS
> 60401 */
>  /* 6.11.xx  - Make Logical Drive Info structure safe for DMA      DDTS
> 60639 */

your patch is still line wrapped.. please fix your email client.

--=-4vjjJCD67lZt1blC0WOA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC5OJ9pv2rCoFn+CIRAoPwAJ4m8xWpsLf6yV5kYtO9qnvGTCzwbACgilBN
k2NwuUFqW2Rzvl3qi5kr+WQ=
=Fjq4
-----END PGP SIGNATURE-----

--=-4vjjJCD67lZt1blC0WOA--

