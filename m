From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/71] ncr5380: Remove redundant static variable
 initializers
Date: Thu, 19 Nov 2015 08:37:48 +0100
Message-ID: <564D7C4C.3030101@suse.de>
References: <20151118083455.331768508@telegraphics.com.au>
 <20151118083455.851692026@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118083455.851692026@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:34 AM, Finn Thain wrote:
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c   |    2 +-
>   drivers/scsi/dtc.c       |    4 ++--
>   drivers/scsi/g_NCR5380.c |    4 ++--
>   drivers/scsi/pas16.c     |   10 +++++-----
>   drivers/scsi/sun3_scsi.c |    8 ++++----
>   drivers/scsi/t128.c      |    4 ++--
>   6 files changed, 16 insertions(+), 16 deletions(-)
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
