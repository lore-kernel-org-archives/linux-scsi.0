From: Christoph Hellwig <hch@lst.de>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Fri, 27 Jan 2017 17:17:18 +0100
Message-ID: <20170127161718.GA16911@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<20170127161114.GA501@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170127161114.GA501@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@fb.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 27, 2017 at 09:11:14AM -0700, Jens Axboe wrote:
> I've queued this up for 4.11. Since some of the patches had dependencies
> on changes in master since for-4.11/block was forked, they are sitting
> in a separate branch that has both for-4.11/block and v4.10-rc5 pulled
> in first. for-next has everything, as usual.

Eww.  I just had a couple non-trivial updates that I now do again.
In case you haven't pushed it out yet can you let me repost first?
