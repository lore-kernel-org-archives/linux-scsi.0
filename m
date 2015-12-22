From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 65/77] atari_scsi, sun3_scsi: Remove global Scsi_Host
 pointer
Date: Tue, 22 Dec 2015 09:03:17 +0100
Message-ID: <567903C5.80002@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011755.696231952@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011755.696231952@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> This refactoring removes two global Scsi_Host pointers. This
> improves consistency with other ncr5380 drivers. Adopting the same
> conventions as the other drivers makes them easier to read.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/atari_NCR5380.c |    5 +-
>   drivers/scsi/atari_scsi.c    |   29 ++++++++---------
>   drivers/scsi/sun3_scsi.c     |   72 ++++++++++---------------------=
------------
>   3 files changed, 36 insertions(+), 70 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
