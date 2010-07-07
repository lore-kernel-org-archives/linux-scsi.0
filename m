From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] block: push BKL into blktrace ioctls
Date: Tue, 6 Jul 2010 21:50:36 -0400
Message-ID: <20100707015036.GD2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-4-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278193640-24223-4-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 03, 2010 at 11:47:17PM +0200, Arnd Bergmann wrote:
> The blktrace driver currently needs the BKL, but
> we should not need to take that in the block layer,
> so just push it down into the driver itself.

Does blktrace actually need it?  Anyway, pushing it down is a good
start.


Reviewed-by: Christoph Hellwig <hch@lst.de>
