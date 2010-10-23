From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] block: remove REQ_HARDBARRIER
Date: Sat, 23 Oct 2010 21:07:26 +0200
Message-ID: <4CC3326E.5020009@fusionio.com>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <201008241745.35242.philipp.reisner@linbit.com> <20101022083511.GA7853@lst.de> <201010231318.33517.philipp.reisner@linbit.com> <4CC311D5.9040904@fusionio.com> <20101023165924.GA1395@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101023165924.GA1395@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2010-10-23 18:59, Christoph Hellwig wrote:
> REQ_HARDBARRIER is dead now, so remove the leftovers.  What's left
> at this point is:
> 
>  - various checks inside the block layer.
>  - sanity checks in bio based drivers.
>  - now unused bio_empty_barrier helper.
>  - Xen blockfront use of BLKIF_OP_WRITE_BARRIER - it's dead for a while,
>    but Xen really needs to sort out it's barrier situaton.
>  - setting of ordered tags in uas - dead code copied from old scsi
>    drivers.
>  - scsi different retry for barriers - it's dead and should have been
>    removed when flushes were converted to FS requests.
>  - blktrace handling of barriers - removed.  Someone who knows blktrace
>    better should add support for REQ_FLUSH and REQ_FUA, though.

Thanks Christoph, applied for 2.6.37 (but with a few days of brewing).

-- 
Jens Axboe
