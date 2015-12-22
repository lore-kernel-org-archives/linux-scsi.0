From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 51/77] ncr5380: Remove command list debug code
Date: Tue, 22 Dec 2015 08:47:29 +0100
Message-ID: <56790011.4040302@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011751.836236766@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011751.836236766@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Some NCR5380 hosts offer a .show_info method to access the contents o=
f
> the various command list data structures from a procfs file. When NDE=
BUG
> is set, the same information is sent to the console during EH.
>
> The two core drivers, atari_NCR5380.c and NCR5380.c differ here. Beca=
use
> it is just for debugging, the easiest way to fix the discrepancy is
> simply remove this code.
>
> The only remaining users of NCR5380_show_info() and NCR5380_write_inf=
o()
> are drivers that define PSEUDO_DMA. The others have no use for the
> .show_info method, so don't initialize it.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   70 ++-----------------------------=
-
>   drivers/scsi/arm/oak.c       |    2
>   drivers/scsi/atari_NCR5380.c |   94 +------------------------------=
------------
>   drivers/scsi/atari_scsi.c    |    2
>   drivers/scsi/g_NCR5380.c     |    1
>   drivers/scsi/sun3_scsi.c     |    2
>   6 files changed, 9 insertions(+), 162 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
