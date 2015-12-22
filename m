From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 58/77] ncr5380: Refactor command completion
Date: Tue, 22 Dec 2015 08:56:10 +0100
Message-ID: <5679021A.6090608@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011753.785498401@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011753.785498401@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Implement a 'complete_cmd' function to complete commands. This is nee=
ded
> by the following patch; the new function provides a site for the logi=
c
> needed to correctly handle REQUEST SENSE commands.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   31 ++++++++++++++++++++++------
>   drivers/scsi/atari_NCR5380.c |   46 ++++++++++++++++++++++++++++---=
------------
>   2 files changed, 55 insertions(+), 22 deletions(-)
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
