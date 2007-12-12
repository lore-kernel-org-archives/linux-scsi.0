From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/30] blk_end_request: full I/O completion handler
	(take 4)
Date: Wed, 12 Dec 2007 13:00:31 +0100
Message-ID: <20071212120031.GB22544@kernel.dk>
References: <20071211.173936.122828268.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071211.173936.122828268.k-ueda@ct.jp.nec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 11 2007, Kiyoshi Ueda wrote:
> Hi Jens, Boaz,
> 
> The following is the updated patch-set for blk_end_request().
> I have done some interface/implementation changes based on
> feedbacks/discussions since the previous version.
> (Although this patch-set was made on top of 2.6.24-rc4, I confirmed
>  it can be applied to 2.6.24-rc5, too.  Also, I confirmed it has
>  no build error on my IA64 box.)

Trying to apply this, but it fails from patch #24 and on:

patching file block/ll_rw_blk.c
Hunk #1 succeeded at 3852 (offset 49 lines).
Hunk #2 succeeded at 3867 with fuzz 2 (offset 49 lines).
Hunk #3 succeeded at 3904 with fuzz 1 (offset 66 lines).
Hunk #4 FAILED at 3916.
Hunk #5 succeeded at 3967 with fuzz 2 (offset 60 lines).
1 out of 5 hunks FAILED -- saving rejects to file block/ll_rw_blk.c.rej
patching file include/linux/blkdev.h
Reversed (or previously applied) patch detected!  Assume -R? [n] 

This is 2.6.24-rc5 (pretty close to at least, no changes to ll_rw_blk.c
from that version). Are you using quilt and forgot to refresh, or
something like that?

-- 
Jens Axboe

