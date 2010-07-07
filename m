From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] block: remove BKL from BLKROSET and BLKFLSBUF
Date: Tue, 6 Jul 2010 21:52:32 -0400
Message-ID: <20100707015232.GF2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-5-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278193640-24223-5-git-send-email-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 03, 2010 at 11:47:18PM +0200, Arnd Bergmann wrote:
> We only call the functions set_device_ro(),
> invalidate_bdev(), sync_filesystem() and sync_blockdev()
> while holding the BKL in these commands. All
> of these are also done in other code paths without
> the BKL, which leads me to the conclusion that
> the BKL is not needed here either.
> 
> The reason we hold it here is that it was originally
> pushed down into the ioctl function from vfs_ioctl.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

