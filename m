From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 28/77] ncr5380: Drop DEF_SCSI_QCMD macro
Date: Tue, 22 Dec 2015 08:24:22 +0100
Message-ID: <5678FAA6.9040203@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011745.645515446@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011745.645515446@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Remove the DEF_SCSI_QCMD macro (already removed from atari_NCR5380.c)=
=2E The
> lock provided by DEF_SCSI_QCMD is only needed for queue data structur=
es.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   30 +++++++++++++++---------------
>   drivers/scsi/atari_NCR5380.c |    2 +-
>   2 files changed, 16 insertions(+), 16 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
