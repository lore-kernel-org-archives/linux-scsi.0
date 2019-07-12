From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V6 2/4] block: Kill gfp_t argument of
 blkdev_report_zones()
Date: Thu, 11 Jul 2019 20:24:18 -0400
Message-ID: <yq11ryw9k25.fsf@oracle.com>
References: <20190701050918.27511-1-damien.lemoal@wdc.com>
 <20190701050918.27511-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190701050918.27511-3-damien.lemoal@wdc.com> (Damien Le Moal's
 message of "Mon, 1 Jul 2019 14:09:16 +0900")
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org


Damien,

> Only GFP_KERNEL and GFP_NOIO are used with blkdev_report_zones(). In
> preparation of using vmalloc() for large report buffer and zone array
> allocations used by this function, remove its "gfp_t gfp_mask" argument
> and rely on the caller context to use memalloc_noio_save/restore() where
> necessary (block layer zone revalidation and dm-zoned I/O error path).

LGTM.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
