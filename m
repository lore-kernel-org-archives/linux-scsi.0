From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 62/77] ncr5380: Implement new eh_bus_reset_handler
Date: Tue, 22 Dec 2015 09:01:41 +0100
Message-ID: <56790365.30906@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011754.875495600@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011754.875495600@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> NCR5380.c lacks a sane eh_bus_reset_handler. The atari_NCR5380.c code=
 is
> much better but it should not throw out the issue queue (that would b=
e
> a host reset) and it neglects to set the result code for commands tha=
t it
> throws out. Fix these bugs and keep the two core drivers in sync.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   50 +++++++++++++++++++++++++++++++=
+++++++++++-
>   drivers/scsi/atari_NCR5380.c |   39 +++++++++++++++++++------------=
--
>   2 files changed, 72 insertions(+), 17 deletions(-)
>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
