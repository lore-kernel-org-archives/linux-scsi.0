From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 17/77] ncr5380: Keep BSY asserted when entering
 SELECTION phase
Date: Tue, 22 Dec 2015 08:01:49 +0100
Message-ID: <5678F55D.9020200@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011742.635457254@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011742.635457254@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:17 AM, Finn Thain wrote:
> NCR5380.c is not compliant with the SCSI-2 standard (at least, not wi=
th
> the draft revision 10L that I have to refer to). The selection algori=
thm
> in atari_NCR5380.c is correct, so use that.
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
