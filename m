From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Announcing ServeRAID driver ( ips ) Version 7.10.18
Date: Tue, 24 Aug 2004 23:37:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093383438.4230.1.camel@laptop.fenrus.com>
References: <A121ABA5B472B74EB59076B8E3C8F01969ABB4@rtpe2k01.adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-26z5zZl6P3h807mPkTNV"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:62652 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S268378AbUHXViP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 17:38:15 -0400
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F01969ABB4@rtpe2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, coughlan@redhat.com, dledford@redhat.com, bjohnson@redhat.com, bhlim@vmware.com, rofarrell@vmware.com, mantel@suse.de, kerneldriver@suse.de, go@turbolinux.co.jp, rogerv@sco.com, schwab@suse.de, axboe@suse.de, michael@turbolinux.com, vcat@caldera.com, sdenham@redhat.com, "Jeffery, David" <David_Jeffery@adaptec.com>, "Pasteur, Bob" <bob_pasteur@adaptec.com>, "Wendy Hung (E-mail)" <wendyh@us.ibm.com>, "Leah Cunningham (E-mail)" <leahc@us.ibm.com>, "Brad Thomas (E-mail)" <bwthomas@us.ibm.com>, "Felica Turner (E-mail)" <faturner@us.ibm.com>, "Marie Jazynka (E-mail)" <mjazynka@us.ibm.com>, Chris McDermott <lcm@us.ibm.com>, "Williams, Bill" <Bill_Williams@adaptec.com>, torvalds@transmeta.com, marcelo@cyclades.com


--=-26z5zZl6P3h807mPkTNV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-08-24 at 16:22, Hammer, Jack wrote:
> +
> +#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,5,0)
> +#include "hosts.h"
> +#else
>  #include <scsi/scsi_host.h>
> +#endif

I thought you said this was the 2.6 driver...
oh and 2.4 kernels also have <scsi/scsi_host.h> so no need for adding
this ifdef.

>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
>   .use_new_eh_code =3D 1,
>  #endif
> +#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,20)  &&
> LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
> +    .highmem_io          =3D 1,  =20
> +#endif

again.... this is the 2.6 driver, right?
> +
> +#ifdef MODULE_DESCRIPTION
> +MODULE_DESCRIPTION("IBM ServeRAID Adapter Driver " IPS_VER_STRING);
> +#endif

all kernels have MODULE_DESCRIPTION so why the ifdef ?


--=-26z5zZl6P3h807mPkTNV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBK7UOxULwo51rQBIRAh/kAJ0THw+Pi4nKssQQ26WRWIQoyOctYACfTx4V
PdryRFcD7Fxs9r4GldmpQtA=
=tDEs
-----END PGP SIGNATURE-----

--=-26z5zZl6P3h807mPkTNV--

