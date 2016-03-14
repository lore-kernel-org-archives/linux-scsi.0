From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/22] ncr5380: Remove PSEUDO_DMA macro
Date: Mon, 14 Mar 2016 08:28:09 +0100
Message-ID: <56E66809.7090100@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042702.216030077@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042702.216030077@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> For those wrapper drivers which only implement Programmed IO, have
> NCR5380_dma_xfer_len() evaluate to zero. That allows PDMA to be easil=
y
> disabled at run-time and so the PSEUDO_DMA macro is no longer needed.
>=20
> Also remove the spin counters used for debugging pseudo DMA drivers.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c      |   32 +-------------------------------
>  drivers/scsi/NCR5380.h      |    4 ----
>  drivers/scsi/arm/cumana_1.c |    2 --
>  drivers/scsi/arm/oak.c      |    3 +--
>  drivers/scsi/dmx3191d.c     |    4 ++++
>  drivers/scsi/dtc.c          |    7 -------
>  drivers/scsi/dtc.h          |    2 --
>  drivers/scsi/g_NCR5380.c    |    1 -
>  drivers/scsi/g_NCR5380.h    |    1 -
>  drivers/scsi/mac_scsi.c     |   10 ----------
>  drivers/scsi/pas16.c        |   10 ----------
>  drivers/scsi/pas16.h        |    2 --
>  drivers/scsi/t128.c         |    4 ----
>  drivers/scsi/t128.h         |    2 --
>  14 files changed, 6 insertions(+), 78 deletions(-)
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
