From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 34/77] atari_NCR5380: Use arbitration timeout
Date: Tue, 22 Dec 2015 08:30:09 +0100
Message-ID: <5678FC01.5000400@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011747.275501704@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011747.275501704@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Allow target selection to fail with a timeout instead of waiting in
> infinite loops. This gets rid of the unused NCR_TIMEOUT macro, it is =
more
> defensive and has proved helpful in debugging.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   44 ++++++++++++++++++-------------=
--
>   drivers/scsi/atari_NCR5380.c |   57 ++++++++++++++++++-------------=
------------
>   2 files changed, 49 insertions(+), 52 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
