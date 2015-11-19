From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/71] ncr5380: Eliminate PDEBUG*, TDEBUG* and DTCDEBUG*
 macros
Date: Thu, 19 Nov 2015 08:38:12 +0100
Message-ID: <564D7C64.9060004@suse.de>
References: <20151118083455.331768508@telegraphics.com.au>
 <20151118083456.101681148@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118083456.101681148@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:34 AM, Finn Thain wrote:
> Replace {P,T,DTC}DEBUG_INIT with NDEBUG_INIT. Remove dead debugging
> code, including code that's conditional upon *DEBUG_TRANSFER.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/dtc.c   |   18 ++++++------------
>   drivers/scsi/dtc.h   |   27 ---------------------------
>   drivers/scsi/pas16.c |   21 +++++++--------------
>   drivers/scsi/pas16.h |   16 ----------------
>   drivers/scsi/t128.c  |   18 ++++++------------
>   drivers/scsi/t128.h  |   16 ----------------
>   6 files changed, 19 insertions(+), 97 deletions(-)
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
