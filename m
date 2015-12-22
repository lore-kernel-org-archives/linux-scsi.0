From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 30/77] ncr5380: Add missing break after case
 MESSAGE_REJECT
Date: Tue, 22 Dec 2015 08:26:02 +0100
Message-ID: <5678FB0A.9020900@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011746.205576191@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011746.205576191@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> MESSAGE REJECT does not imply DISCONNECT: the target is about to ente=
r
> MESSAGE IN or MESSAGE OUT phase.
>
> This bug fix comes from atari_NCR5380.c. Unfortunately it never made =
it
> into the original NCR5380.c core driver.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c |    1 +
>   1 file changed, 1 insertion(+)
>
> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:16.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:17.000000000 +1100
> @@ -1990,6 +1990,7 @@ static void NCR5380_information_transfer
>   					default:
>   						break;
>   					}
> +					break;
>   				case DISCONNECT:{
>   						/* Accept message by clearing ACK */
>   						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
