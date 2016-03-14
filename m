From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 18/22] ncr5380: Remove DONT_USE_INTR and AUTOPROBE_IRQ
 macros
Date: Mon, 14 Mar 2016 08:47:16 +0100
Message-ID: <56E66C84.5050406@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042705.346693900@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160314042705.346693900@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c   |   12 +-----------
>  drivers/scsi/NCR5380.h   |    4 ----
>  drivers/scsi/arm/oak.c   |    2 --
>  drivers/scsi/dmx3191d.c  |    2 --
>  drivers/scsi/dtc.c       |   12 +++---------
>  drivers/scsi/g_NCR5380.c |    2 --
>  drivers/scsi/pas16.c     |    1 -
>  drivers/scsi/t128.c      |    1 -
>  8 files changed, 4 insertions(+), 32 deletions(-)
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
