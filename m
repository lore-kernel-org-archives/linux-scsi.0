From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 29/77] ncr5380: Remove references to linked commands
Date: Tue, 22 Dec 2015 08:25:28 +0100
Message-ID: <5678FAE8.9060501@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011745.905485656@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011745.905485656@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> From: Hannes Reinecke <hare@suse.de>
>
> Some old drivers partially implemented support for linked commands us=
ing
> a "proposed" next_link pointer in struct scsi_cmnd that never actuall=
y
> existed. Remove this code.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>
> This is a modified version of Hannes' patch so I have dropped his
> signed-off-by tag. This version has a rewritten commit log and also
> removes additional references to linked commands from comments. This
> version also omits the sun3_NCR5380.c changes since that file no
> longer exists.
>
> ---
>   drivers/scsi/NCR5380.c       |   42 ------------------------------
>   drivers/scsi/atari_NCR5380.c |   60 -------------------------------=
------------
>   2 files changed, 102 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
