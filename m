From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 22/22] mac_scsi: Fix pseudo DMA implementation
Date: Mon, 14 Mar 2016 08:59:47 +0100
Message-ID: <56E66F73.5030402@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042706.346025449@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042706.346025449@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Fix various issues: Comments about bus errors are incorrect. The
> PDMA asm must return the size of the memory access that faulted so th=
e
> transfer count can be adjusted accordingly. A phase change may cause =
a
> bus error but should not be treated as failure. A bus error does not
> always imply a phase change and generally the transfer may continue.
> Scatter/gather can't be used with PDMA due to overruns (which is a pi=
ty
> because peak throughput seems to double with SG_ALL).
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.h  |    2=20
>  drivers/scsi/mac_scsi.c |  210 ++++++++++++++++++++++++++-----------=
-----------
>  2 files changed, 118 insertions(+), 94 deletions(-)
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
