From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 37/77] ncr5380: Standardize work queueing algorithm
Date: Tue, 22 Dec 2015 08:33:16 +0100
Message-ID: <5678FCBC.4080404@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011748.092136137@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011748.092136137@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> The complex main_running/queue_main mechanism is peculiar to
> atari_NCR5380.c. It isn't SMP safe and offers little value given that
> the work queue already offers concurrency management. Remove this
> complexity to bring atari_NCR5380.c closer to NCR5380.c.
>
> It is not a good idea to call the information transfer state machine =
from
> queuecommand because, according to Documentation/scsi/scsi_mid_low_ap=
i.txt
> that could happen in soft irq context. Fix this.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.h       |    1
>   drivers/scsi/atari_NCR5380.c |   80 +++----------------------------=
------------
>   2 files changed, 6 insertions(+), 75 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
