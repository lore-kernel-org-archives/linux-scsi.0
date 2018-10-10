From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/11] scsi: sd_zbc: Rearrange code
Date: Wed, 10 Oct 2018 15:25:33 +0200
Message-ID: <20181010132533.GA22273@lst.de>
References: <20181010015239.24930-1-damien.lemoal@wdc.com>
	<20181010015239.24930-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010015239.24930-2-damien.lemoal@wdc.com>
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

On Wed, Oct 10, 2018 at 10:52:29AM +0900, Damien Le Moal wrote:
> Move the urswrz check out of sd_zbc_read_zones() and into
> sd_zbc_read_zoned_characteristics() where that value is obtained (read
> from the disk zoned characteristics VPD page). Since this function now
> does more than simply reading the VPD page, rename it to
> sd_zbc_check_zoned_characteristics().
> Also fix the error message displayed when reading that VPD page fails.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
