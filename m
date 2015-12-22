From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 33/77] atari_NCR5380: Set do_abort() timeouts
Date: Tue, 22 Dec 2015 08:29:11 +0100
Message-ID: <5678FBC7.2030406@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011746.975776159@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011746.975776159@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Use timeouts in do_abort() in atari_NCR5380.c instead of infinite loo=
ps.
> Also fix the kernel-doc comment. Keep the two core driver forks in sy=
nc.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   26 +++++++++++++-------------
>   drivers/scsi/atari_NCR5380.c |   34 +++++++++++++++++++++----------=
---
>   2 files changed, 34 insertions(+), 26 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
