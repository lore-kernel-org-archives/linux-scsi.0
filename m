From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 12/16] scsi: fc: use bsg_softirq_done
Date: Thu, 13 Oct 2016 13:45:38 +0200
Message-ID: <cec7c174-288b-2740-e7d0-90b1dac881a2@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <4bf6d3e57ce4637effcc763e5f5ed6166b32f518.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4bf6d3e57ce4637effcc763e5f5ed6166b32f518.1476276823.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> bsg_softirq_done() and fc_bsg_softirq_done() are copies of each other, so
> ditch the fc specific one.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  block/bsg-lib.c                  |  3 ++-
>  drivers/scsi/scsi_transport_fc.c | 16 ++--------------
>  include/linux/bsg-lib.h          |  1 +
>  3 files changed, 5 insertions(+), 15 deletions(-)
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
