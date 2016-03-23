From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 14/23] ncr5380: Reduce max_lun limit
Date: Wed, 23 Mar 2016 08:28:20 +0100
Message-ID: <56F24594.3050600@suse.de>
References: <20160321023149.604138431@telegraphics.com.au>
 <20160321023153.323999176@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160321023153.323999176@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/21/2016 03:32 AM, Finn Thain wrote:
> The driver has a limit of eight LUs because of the byte-sized bitfiel=
d
> that is used for busy flags. That means the maximum LUN is 7. The def=
ault
> is 8.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
>=20
> ---
>=20
> Changed since v1:
> - Reduce shost->max_lun limit instead of adding 'MAX_LUN' limit.
>=20
> ---
>  drivers/scsi/NCR5380.c |    2 ++
>  1 file changed, 2 insertions(+)
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
