From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/22] ncr5380: Merge DMA implementation from
 atari_NCR5380 core driver
Date: Mon, 14 Mar 2016 08:38:26 +0100
Message-ID: <56E66A72.8090906@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042703.226339838@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042703.226339838@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> Adopt the DMA implementation from atari_NCR5380.c. This means that
> atari_scsi and sun3_scsi can make use of the NCR5380.c core driver
> and the atari_NCR5380.c driver fork can be made redundant.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c      |  170 +++++++++++++++++++++++++++++++++=
++---------
>  drivers/scsi/arm/cumana_1.c |    3=20
>  drivers/scsi/arm/oak.c      |    3=20
>  drivers/scsi/dmx3191d.c     |    1=20
>  drivers/scsi/dtc.c          |    2=20
>  drivers/scsi/dtc.h          |    1=20
>  drivers/scsi/g_NCR5380.c    |    2=20
>  drivers/scsi/g_NCR5380.h    |    1=20
>  drivers/scsi/mac_scsi.c     |    3=20
>  drivers/scsi/pas16.c        |    2=20
>  drivers/scsi/pas16.h        |    1=20
>  drivers/scsi/t128.c         |    2=20
>  drivers/scsi/t128.h         |    1=20
>  13 files changed, 152 insertions(+), 40 deletions(-)
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
