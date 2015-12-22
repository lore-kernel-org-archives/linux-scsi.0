From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 72/77] ncr5380: Fix pseudo DMA transfers on 53C400
Date: Tue, 22 Dec 2015 09:06:39 +0100
Message-ID: <5679048F.9090000@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011757.605771566@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011757.605771566@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> From: Ondrej Zary <linux@rainbow-software.org>
>
> Pseudo-DMA (PDMA) has been broken for ages, resulting in hangs on
> 53C400-based cards.
>
> According to 53C400 datasheet, PDMA transfer length must be a multipl=
e
> of 128. Check if that's true and use PIO if it's not.
>
> This makes PDMA work on 53C400 (Canon FG2-5202).
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
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
