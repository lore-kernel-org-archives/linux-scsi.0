From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/22] ncr5380: Remove FLAG_NO_PSEUDO_DMA where possible
Date: Mon, 14 Mar 2016 08:21:55 +0100
Message-ID: <56E66693.1090901@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042701.115991238@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160314042701.115991238@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Drivers that define PSEUDO_DMA also define NCR5380_dma_xfer_len.
> The core driver must call NCR5380_dma_xfer_len which means
> FLAG_NO_PSEUDO_DMA can be eradicated from the core driver.
>=20
> dmx3191d doesn't define PSEUDO_DMA and has no use for FLAG_NO_PSEUDO_=
DMA,
> so remove it there also.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c   |    3 +--
>  drivers/scsi/dmx3191d.c  |    2 +-
>  drivers/scsi/g_NCR5380.c |    7 ++++++-
>  drivers/scsi/g_NCR5380.h |    2 +-
>  drivers/scsi/mac_scsi.c  |   15 ++++++++++++++-
>  5 files changed, 23 insertions(+), 6 deletions(-)
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
