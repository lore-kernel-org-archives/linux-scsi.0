From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/71] atari_NCR5380: Reset bus on driver initialization
 if required
Date: Thu, 19 Nov 2015 14:38:45 +0100
Message-ID: <564DD0E5.2010609@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083457.631722643@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118083457.631722643@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> Merge the bus reset code from NCR5380.c into atari_NCR5380.c. This al=
lows
> for removal of a lot of duplicated code conditional on the RESET_BOOT
> macro (in the next patch).
>=20
> The atari_NCR5380.c fork lacks the do_reset() and NCR5380_poll_polite=
ly()
> routines from NCR5380.c, so introduce them. They are indispensible. K=
eep
> the two implementations in sync.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c       |   33 +++++++-----
>  drivers/scsi/atari_NCR5380.c |  113 ++++++++++++++++++++++++++++++++=
+++++++++++
>  2 files changed, 134 insertions(+), 12 deletions(-)
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
