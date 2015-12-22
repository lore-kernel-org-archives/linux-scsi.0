From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 52/77] ncr5380: Remove H_NO macro and introduce
 dsprintk
Date: Tue, 22 Dec 2015 08:48:21 +0100
Message-ID: <56790045.7070804@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011752.125522855@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011752.125522855@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Replace all H_NO and some HOSTNO macros (both peculiar to atari_NCR53=
80.c)
> with a new dsprintk macro that's more useful and more consistent. The=
 new
> macro avoids a lot of boilerplate in new code in subsequent patches. =
Keep
> NCR5380.c in sync. Remaining HOSTNO macros are removed as side-effect=
s
> of subsequent patches.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |    9 ++++---
>   drivers/scsi/NCR5380.h       |    5 +++
>   drivers/scsi/atari_NCR5380.c |   54 +++++++++++++++++++++----------=
------------
>   3 files changed, 38 insertions(+), 30 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
