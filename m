From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 20/23] atari_scsi: Set a reasonable default for
 cmd_per_lun
Date: Wed, 23 Mar 2016 08:28:54 +0100
Message-ID: <56F245B6.2030007@suse.de>
References: <20160321023149.604138431@telegraphics.com.au>
 <20160321023154.853970340@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160321023154.853970340@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/21/2016 03:32 AM, Finn Thain wrote:
> This setting does not need to be conditional on Atari ST or TT.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
>=20
> ---
>=20
> Changed since v1:
> - Set the default cmd_per_lun to 4 based on test results.
>=20
> Changed since v2:
> - Revert the default cmd_per_lun to 2, like in the v1 patch, because
> a uniform default across all ten 5380 wrapper drivers is worth more
> than a tiny improvement in one particular microbenchmark on one syste=
m.
> Michael tells me that 2 is also the best setting for his Atari Falcon=
=2E
>=20
> ---
>  drivers/scsi/atari_scsi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
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
