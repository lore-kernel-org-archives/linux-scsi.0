From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 32/77] ncr5380: Fix bus phase in do_abort()
Date: Tue, 22 Dec 2015 08:27:22 +0100
Message-ID: <5678FB5A.3020203@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011746.705515883@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011746.705515883@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> NCR5380_poll_politely() returns either 0 (success) or -ETIMEDOUT. How=
ever,
> in do_abort(), the return value is incorrectly taken to be the status
> register value. This means that the bus is put into DATA OUT phase in=
stead
> of MESSAGE OUT. Fix this.
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
