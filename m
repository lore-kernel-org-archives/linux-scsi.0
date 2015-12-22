From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 26/77] ncr5380: Fix NCR5380_transfer_pio() result
Date: Tue, 22 Dec 2015 08:22:40 +0100
Message-ID: <5678FA40.4040309@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011745.091589071@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011745.091589071@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> According to the SCSI-2 draft revision 10L, atari_NCR5380.c is correc=
t
> when it says that the phase lines are valid up until ACK is negated
> following the transmission of the last byte in MESSAGE IN phase. This=
 is
> true for all information transfer phases, from target to initiator.
>
> Sample the phase bits in STATUS_REG so that NCR5380_transfer_pio() ca=
n
> return the correct result. The return value is presently unused (perh=
aps
> because of bugs like this) but this change at least fixes the caller'=
s
> phase variable, which is passed by reference.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   12 +++++++++---
>   drivers/scsi/atari_NCR5380.c |   11 ++++++-----
>   2 files changed, 15 insertions(+), 8 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
