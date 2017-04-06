From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 27/27] scsi: sd: Remove LBPRZ dependency for discards
Date: Thu, 6 Apr 2017 08:18:20 +0200
Message-ID: <8037a5d5-3c9c-35cc-0dd7-811342cc8343@suse.de>
References: <20170405172125.22600-1-hch@lst.de>
 <20170405172125.22600-28-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405172125.22600-28-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/05/2017 07:21 PM, Christoph Hellwig wrote:
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> Separating discards and zeroout operations allows us to remove the LBPRZ
> block zeroing constraints from discards and honor the device preferences
> for UNMAP commands.
> 
> If supported by the device, we'll also choose UNMAP over one of the
> WRITE SAME variants for discards.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 25 ++++++-------------------
>  1 file changed, 6 insertions(+), 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
