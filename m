From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/71] ncr5380: Remove more pointless macros
Date: Thu, 19 Nov 2015 08:38:36 +0100
Message-ID: <564D7C7C.4080002@suse.de>
References: <20151118083455.331768508@telegraphics.com.au>
 <20151118083456.362586813@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083456.362586813@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:34 AM, Finn Thain wrote:
> ASM macro is never defined. rtrc in pas16.c is not used.
> NCR5380_map_config, do_NCR5380_intr, do_t128_intr and do_pas16_intr
> are unused. NCR_NOT_SET harms readability. Remove them.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.h   |    3 ---
>   drivers/scsi/g_NCR5380.c |   29 ++++++++++++++---------------
>   drivers/scsi/g_NCR5380.h |    5 -----
>   drivers/scsi/pas16.c     |   16 ----------------
>   drivers/scsi/pas16.h     |    5 -----
>   drivers/scsi/t128.h      |    4 ----
>   6 files changed, 14 insertions(+), 48 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
