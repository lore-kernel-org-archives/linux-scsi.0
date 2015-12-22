From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 47/77] ncr5380: Fix and cleanup scsi_host_template
 initializers
Date: Tue, 22 Dec 2015 08:43:18 +0100
Message-ID: <5678FF16.4030406@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011750.776106983@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011750.776106983@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Add missing .module initializer. Use distinct .proc_name values for t=
he
> g_NCR5380 and g_NCR5380_mmio modules. Remove pointless CAN_QUEUE and
> CMD_PER_LUN override macros. Cleanup whitespace and code style.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/atari_scsi.c |    2 +-
>   drivers/scsi/dmx3191d.c   |    1 +
>   drivers/scsi/dtc.c        |   32 ++++++++++++++++----------------
>   drivers/scsi/dtc.h        |    8 --------
>   drivers/scsi/g_NCR5380.c  |   26 +++++++++++++-------------
>   drivers/scsi/g_NCR5380.h  |   10 ++--------
>   drivers/scsi/mac_scsi.c   |   28 ++++++++++++++--------------
>   drivers/scsi/pas16.c      |   32 ++++++++++++++++----------------
>   drivers/scsi/pas16.h      |    8 --------
>   drivers/scsi/sun3_scsi.c  |    6 +++---
>   drivers/scsi/t128.c       |   32 ++++++++++++++++----------------
>   drivers/scsi/t128.h       |    8 --------
>   12 files changed, 82 insertions(+), 111 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
