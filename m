From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/22] dmx3191d: Drop max_sectors limit
Date: Mon, 14 Mar 2016 08:43:54 +0100
Message-ID: <56E66BBA.2000207@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042704.546012961@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160314042704.546012961@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> The dmx3191d driver is not capable of DMA or PDMA so all transfers
> use PIO. Now that large slow PIO transfers periodically stop and call
> cond_resched(), the max_sectors limit can go away.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/dmx3191d.c |    1 -
>  1 file changed, 1 deletion(-)
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
