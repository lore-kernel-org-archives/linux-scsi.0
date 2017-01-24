From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/16] block: split scsi_request out of struct request
Date: Tue, 24 Jan 2017 14:21:39 +0100
Message-ID: <4a5c941f-5fc2-bb9d-b22f-8fc3bede3ae9@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-16-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-16-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> And require all drivers that want to support BLOCK_PC to allocate it
> as the first thing of their private data.  To support this the legacy
> IDE and BSG code is switched to set cmd_size on their queues to let
> the block layer allocate the additional space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
