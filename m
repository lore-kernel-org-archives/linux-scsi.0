From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/11] block: Introduce blkdev_nr_zones()
	helper
Date: Wed, 10 Oct 2018 15:26:39 +0200
Message-ID: <20181010132639.GD22273@lst.de>
References: <20181010015239.24930-1-damien.lemoal@wdc.com>
	<20181010015239.24930-5-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010015239.24930-5-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 10, 2018 at 10:52:32AM +0900, Damien Le Moal wrote:
> Introduce the blkdev_nr_zones() helper function to get the total
> number of zones of a zoned block device. This number is always 0 for a
> regular block device (q->limits.zoned == BLK_ZONED_NONE case).
> 
> Replace hard-coded number of zones calculation in dmz_get_zoned_device()
> with a call to this helper.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
