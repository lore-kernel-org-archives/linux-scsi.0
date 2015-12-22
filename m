From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 77/77] ncr5380: Add support for HP C2502
Date: Tue, 22 Dec 2015 09:09:11 +0100
Message-ID: <56790527.4010006@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011758.956108574@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011758.956108574@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
>
> HP C2502 cards (based on 53C400A chips) use different magic numbers f=
or
> software-based I/O address configuration than other cards.
> The configuration is also extended to allow setting the IRQ.
>
> Move the configuration to a new function magic_configure() and move
> magic the magic numbers into an array. Add new magic numbers for thes=
e
> HP cards and hp_c2502 module parameter to use them, e.g.:
> modprobe g_NCR5380 ncr_irq=3D7 ncr_addr=3D0x280 hp_c2502=3D1
>
> Tested with HP C2502 and DTCT-436P.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
