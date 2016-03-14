From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 17/22] ncr5380: Remove remaining register storage
 qualifiers
Date: Mon, 14 Mar 2016 08:46:33 +0100
Message-ID: <56E66C59.9060702@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042705.056040807@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042705.056040807@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c	2016-03-14 15:26:50.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.c	2016-03-14 15:26:51.000000000 +1100
> @@ -1559,9 +1559,9 @@ static int NCR5380_transfer_dma(struct S
>  				unsigned char **data)
>  {
>  	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
> -	register int c =3D *count;
> -	register unsigned char p =3D *phase;
> -	register unsigned char *d =3D *data;
> +	int c =3D *count;
> +	unsigned char p =3D *phase;
> +	unsigned char *d =3D *data;
>  	unsigned char tmp;
>  	int result =3D 0;
> =20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
