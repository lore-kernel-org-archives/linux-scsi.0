From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request
	V2
Date: Fri, 27 Jan 2017 09:58:34 -0700
Message-ID: <399cdc3b-6875-9547-8342-355e3892d929@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<20170127161114.GA501@kernel.dk> <20170127161718.GA16911@lst.de>
	<775aff8d-6bcc-9cc5-cfa3-dd1c157c95c5@fb.com>
	<20170127162316.GA17059@lst.de>
	<195e1638-7d85-0618-0101-5cfff34b91e9@fb.com>
	<20170127163450.GA17311@lst.de>
	<f0305c67-4aca-e2cf-d729-3ceb93d2cc50@fb.com>
	<20170127164233.GA17438@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170127164233.GA17438@lst.de>
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

On 01/27/2017 09:42 AM, Christoph Hellwig wrote:
> On Fri, Jan 27, 2017 at 09:38:40AM -0700, Jens Axboe wrote:
>>> Ok, I'll repost what I have right now, which is on top of a merge
>>> of your block/for-4.11/next and your for-next from this morning
>>> my time.
>>
>> Perfect.
> 
> At least I tried, looks like the mail server is overloaded and crapped
> out three mails into it.  For now there is a git tree here:
> 
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-pc-refactor

I grabbed it all from there. for-4.11/rq-refactor has been rebased to v3.
Basic testing looks fine here, at least on v2. I'll repeat the same and
then merge it into for-next as well.

-- 
Jens Axboe
