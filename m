From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/15] block copy: initial XCOPY offload support
Date: Mon, 4 Aug 2014 16:09:25 +0200
Message-ID: <20140804140925.GA24261@amd.pavel.ucw.cz>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue 2014-07-15 15:34:47, Mikulas Patocka wrote:
> This is Martin Petersen's xcopy patch
> (https://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=xcopy&id=0bdeed274e16b3038a851552188512071974eea8)
> with some bug fixes, ported to the current kernel.
> 
> This patch makes it possible to use the SCSI XCOPY command.
> 
> We create a bio that has REQ_COPY flag in bi_rw and a bi_copy structure
> that defines the source device. The target device is defined in the
> bi_bdev and bi_iter.bi_sector.
> 
> There is a new BLKCOPY ioctl that makes it possible to use XCOPY from
> userspace. The ioctl argument is a pointer to an array of four uint64_t
> values.

But it is there only for block devices, right?

Is there plan to enable tools such as /bin/cp to use XCOPY?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
