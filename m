From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 04/23] atari_NCR5380: Remove DMA_MIN_SIZE macro
Date: Wed, 23 Mar 2016 08:27:23 +0100
Message-ID: <56F2455B.2080509@suse.de>
References: <20160321023149.604138431@telegraphics.com.au>
 <20160321023150.654436098@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160321023150.654436098@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/21/2016 03:31 AM, Finn Thain wrote:
> Only the atari_scsi and sun3_scsi drivers define DMA_MIN_SIZE.
> Both drivers also define NCR5380_dma_xfer_len, which means
> DMA_MIN_SIZE can be removed from the core driver.
>=20
> This removes another discrepancy between the two core drivers.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
>=20
> ---
>=20
> Changes since v1:
> - Retain MIN_DMA_SIZE macro in wrapper drivers.
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
