From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/22] atari_scsi: Set a reasonable default for
 cmd_per_lun
Date: Mon, 14 Mar 2016 08:49:09 +0100
Message-ID: <56E66CF5.2070200@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042705.846189331@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042705.846189331@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> This setting does not need to be conditional on Atari ST or TT.
>=20
> Without TCQ support, cmd_per_lun =3D=3D 2 is probably reasonable...
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/atari_scsi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> Index: linux/drivers/scsi/atari_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/atari_scsi.c	2016-03-14 15:26:45.00000000=
0 +1100
> +++ linux/drivers/scsi/atari_scsi.c	2016-03-14 15:26:55.000000000 +11=
00
> @@ -750,6 +750,7 @@ static struct scsi_host_template atari_s
>  	.eh_abort_handler	=3D atari_scsi_abort,
>  	.eh_bus_reset_handler	=3D atari_scsi_bus_reset,
>  	.this_id		=3D 7,
> +	.cmd_per_lun		=3D 2,
>  	.use_clustering		=3D DISABLE_CLUSTERING,
>  	.cmd_size		=3D NCR5380_CMD_SIZE,
>  };
_2_ ? Are you being overly cheeky here?
I sincerely doubt the driver is capable of submitting two
simultaneous commands ...
Care to explain?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
