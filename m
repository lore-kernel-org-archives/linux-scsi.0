From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Date: Wed, 7 Jul 2010 16:04:03 +0200
Message-ID: <201007071604.04086.arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-3-git-send-email-arnd@arndb.de> <20100707015000.GC2950@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100707015000.GC2950@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> I might be missing something, but this doesn't actually push the
> BKL anyway.  It adds duplicate BKL locking inside the ->open and
> ->release methods without actually removing it in the callers.
> 
> That's a pretty pointless thing to do.  If you're not feeling
> confident enough about touching block_dev.c I can look into that
> part of the pushdown, but this patch on it's own is not actually
> useful.

My idea was that the patch in its current form would be less
controversial if it can't break anything, but you're certainly
right that the description doesn't match what the patch does.

I'm now integrating the half of patch 5, as you suggested.
I would much appreciate if you could verify my assumptions
about the blkdev_get/blkdev_put functions in the combined patch.

	Arnd
