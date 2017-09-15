From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 06/12] scsi: sd_zbc: Rearrange code
Date: Fri, 15 Sep 2017 12:45:03 +0200
Message-ID: <fb39b6e8-590b-d9e6-7ed2-c61b1be97c2b@suse.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
 <20170915100645.17999-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-7-damien.lemoal@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 09/15/2017 12:06 PM, Damien Le Moal wrote:
> Rearrange sd_zbc_setup() to include use_16_for_rw and use_10_for_rw
> assignments and move the calculation of sdkp->zone_shift together
> with the assignment of the verified zone_blocks value in
> sd_zbc_check_zone_size().
> 
> No functional change is introduced by this patch.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/sd_zbc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
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
