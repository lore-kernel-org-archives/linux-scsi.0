From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Fri, 27 Jan 2017 09:21:46 -0700
Message-ID: <775aff8d-6bcc-9cc5-cfa3-dd1c157c95c5@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<20170127161114.GA501@kernel.dk> <20170127161718.GA16911@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170127161718.GA16911@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/27/2017 09:17 AM, Christoph Hellwig wrote:
> On Fri, Jan 27, 2017 at 09:11:14AM -0700, Jens Axboe wrote:
>> I've queued this up for 4.11. Since some of the patches had dependencies
>> on changes in master since for-4.11/block was forked, they are sitting
>> in a separate branch that has both for-4.11/block and v4.10-rc5 pulled
>> in first. for-next has everything, as usual.
> 
> Eww.  I just had a couple non-trivial updates that I now do again.
> In case you haven't pushed it out yet can you let me repost first?

Why the eww?! You can't fix this with a repost.

It's fine, I'll just ship off for-4.11/block first (as usual), then
for-4.11/rq-refactor.

The two issues is in virtio_blk and raid1. For some reason, raid1
included a refactor of a function later in the cycle (hrmpf). So there's
really no good way to solve this, unless I pull in v4.10-rc5 into
for-4.11/block.  And I don't want to do that. Hence the topic branch for
this work.

I have pushed it out, but it's not merged into for-next yet, it's just
standalone. When I've done some sanity testing, I'll push it out.


-- 
Jens Axboe
