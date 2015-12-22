From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 42/77] ncr5380: Replace READ_OVERRUNS macro with
 FLAG_NO_DMA_FIXUPS
Date: Tue, 22 Dec 2015 08:39:37 +0100
Message-ID: <5678FE39.6090302@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011749.446042594@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011749.446042594@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> The workarounds for chip errata appear twice, in slightly different
> forms. One is used when defined(REAL_DMA) || defined(REAL_DMA_POLL), =
the
> other when defined(PSEUDO_DMA). In the PDMA case, the workarounds hav=
e
> been made conditional on FLAG_NO_DMA_FIXUPS. Do the same for the DMA =
case,
> to eliminate the READ_OVERRUNS macro.
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
