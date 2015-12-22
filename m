From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 31/77] ncr5380: Fix !REQ timeout in do_abort()
Date: Tue, 22 Dec 2015 08:26:47 +0100
Message-ID: <5678FB37.6050707@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011746.445511731@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011746.445511731@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> NCR5380_poll_politely() never returns -1. That means do_abort() can f=
ail
> to handle a timeout after waiting for the target to negate REQ. Fix t=
his
> and cleanup other NCR5380_poll_politely() call sites.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
