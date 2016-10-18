From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v8 1/7] block: Add 'zoned' queue limit
Date: Tue, 18 Oct 2016 08:42:58 +0200
Message-ID: <1e4d596f-e296-7f5c-0976-72c1d09ad71a@suse.de>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
 <1476772835-18541-2-git-send-email-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757533AbcJRGnC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 02:43:02 -0400
In-Reply-To: <1476772835-18541-2-git-send-email-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>

On 10/18/2016 08:40 AM, Damien Le Moal wrote:
> From: Damien Le Moal <damien.lemoal@hgst.com>
> 
> Add the zoned queue limit to indicate the zoning model of a block device.
> Defined values are 0 (BLK_ZONED_NONE) for regular block devices,
> 1 (BLK_ZONED_HA) for host-aware zone block devices and 2 (BLK_ZONED_HM)
> for host-managed zone block devices. The standards defined drive managed
> model is not defined here since these block devices do not provide any
> command for accessing zone information. Drive managed model devices will
> be reported as BLK_ZONED_NONE.
> 
> The helper functions blk_queue_zoned_model and bdev_zoned_model return
> the zoned limit and the functions blk_queue_is_zoned and bdev_is_zoned
> return a boolean for callers to test if a block device is zoned.
> 
> The zoned attribute is also exported as a string to applications via
> sysfs. BLK_ZONED_NONE shows as "none", BLK_ZONED_HA as "host-aware" and
> BLK_ZONED_HM as "host-managed".
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
> Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>
> ---
>  Documentation/ABI/testing/sysfs-block | 16 ++++++++++++
>  block/blk-settings.c                  |  1 +
>  block/blk-sysfs.c                     | 18 ++++++++++++++
>  include/linux/blkdev.h                | 47 +++++++++++++++++++++++++++++++++++
>  4 files changed, 82 insertions(+)
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
