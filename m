From: Hannes Reinecke <hare@suse.de>
Subject: Re: always use REQ_OP_WRITE_ZEROES for zeroing offload
Date: Mon, 3 Apr 2017 08:06:27 +0200
Message-ID: <83c79b9c-362a-c12c-8a75-7e42947a77da@suse.de>
References: <20170331163313.31821-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/31/2017 06:32 PM, Christoph Hellwig wrote:
> This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
> supported by the block layer, and switches existing implementations
> of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
> removes incorrect discard_zeroes_data, and also switches WRITE SAME
> based zeroing in SCSI to this new method.
> 
> The series is against the block for-next tree.
> 
> A git tree is also avaiable at:
> 
>     git://git.infradead.org/users/hch/block.git discard-rework
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/discard-rework
Thank you for doing this.

For this series:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
