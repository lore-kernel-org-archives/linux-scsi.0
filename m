From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/71] ncr5380: Use return instead of goto in NCR5380_select()
Date: Thu, 19 Nov 2015 15:14:55 +0100
Message-ID: <564DD95F.2050906@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083459.021681450@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083459.021681450@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> The "failed" label in NCR5380_select() is not helpful. Some failures
> return 0, others -1. Use return instead of goto to improve clarity an=
d
> brevity, like atari_NCR5380.c does. Fix the relevant comments.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c       |   30 ++++++++----------------------
>  drivers/scsi/atari_NCR5380.c |    6 +++---
>  2 files changed, 11 insertions(+), 25 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
