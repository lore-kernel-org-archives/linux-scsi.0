From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/22] ncr5380: Remove BOARD_REQUIRES_NO_DELAY macro
Date: Mon, 14 Mar 2016 08:33:16 +0100
Message-ID: <56E6693C.4020804@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042702.466021574@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042702.466021574@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> The io_recovery_delay macro is intended to insert a microsecond delay
> between the chip register accesses that begin a DMA operation. This
> is reportedly needed for some ISA boards.
>=20
> Reverse the sense of the macro test so that in the common case,
> where no delay is required, drivers need not define the macro.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c   |   18 ++++++++----------
>  drivers/scsi/dtc.h       |    2 ++
>  drivers/scsi/g_NCR5380.h |    2 ++
>  drivers/scsi/t128.h      |    2 ++
>  4 files changed, 14 insertions(+), 10 deletions(-)
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
