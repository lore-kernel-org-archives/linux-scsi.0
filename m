From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 63/77] atari_NCR5380: Remove HOSTNO macro from printk()
 and seq_printf() calls
Date: Tue, 22 Dec 2015 09:02:09 +0100
Message-ID: <56790381.7060506@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011755.175504840@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011755.175504840@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Remove the HOSTNO macro that is peculiar to atari_NCR5380.c and
> contributes to the problem of divergence of the NCR5380 core drivers.
> Keep NCR5380.c in sync.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
