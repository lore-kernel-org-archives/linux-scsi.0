From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 09/11] block: Expose queue nr_zones in
	sysfs
Date: Fri, 12 Oct 2018 10:29:04 +0200
Message-ID: <20181012082904.GD30248@lst.de>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-10-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181012023012.29923-10-damien.lemoal@wdc.com>
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

On Fri, Oct 12, 2018 at 11:30:10AM +0900, Damien Le Moal wrote:
> Expose through sysfs the nr_zones field of struct request_queue.
> Exposing this value helps in debugging disk issues as well as
> facilitating scripts based use of the disk (e.g. blktests).
> 
> For zoned block devices, the nr_zones field indicates the total number
> of zones of the device calculated using the known disk capacity and
> zone size. This number of zones is always 0 for regular block devices.
> 
> Since nr_zones is defined conditionally with CONFIG_BLK_DEV_ZONED,
> introduce the blk_queue_nr_zones() function to return the correct value
> for any device, regardless if CONFIG_BLK_DEV_ZONED is set.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
