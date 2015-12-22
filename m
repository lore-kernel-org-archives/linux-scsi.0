From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 38/77] ncr5380: Remove UNSAFE macro
Date: Tue, 22 Dec 2015 08:34:09 +0100
Message-ID: <5678FCF1.10305@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011748.365505398@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011748.365505398@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Configuring core drivers using macros like this one prevents re-unify=
ing
> the core driver forks, and prevents implementing the core driver as a
> library or a platform driver.
>
> The UNSAFE macro in particular is a poor workaround for the problem o=
f
> interrupt latency. Releasing the locks complicates things because the=
n we
> would have to handle the possibility of EH handler invocation during =
a
> PDMA transfer.
>
> The comments say that instead of using this macro, "you're going to b=
e
> better off twiddling with transfersize". I agree. Remove this stuff.
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
