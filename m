From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 69/77] ncr5380: Merge changes from atari_NCR5380.c
Date: Tue, 22 Dec 2015 09:05:29 +0100
Message-ID: <56790449.6020804@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011756.785537093@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011756.785537093@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> In the past, NCR5380.c was overlooked by those working on atari_NCR53=
80.c
> and this caused needless divergence. All of the changes in this patch=
 were
> taken from atari_NCR5380.c.
>
> This removes some unimportant discrepancies between the two core driv=
er
> forks so that 'diff' can be used to reveal the important ones, to
> facilitate reunification.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c |  155 +++++++++++++++++++++++++++----------=
------------
>   1 file changed, 87 insertions(+), 68 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
