From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/18] dm: always defer request allocation to
 the owner of the request_queue
Date: Fri, 27 Jan 2017 11:44:53 -0500
Message-ID: <20170127164453.GB30221@redhat.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-8-git-send-email-hch@lst.de>
	<20170127163434.GA30221@redhat.com> <20170127163604.GA17337@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170127163604.GA17337@lst.de>
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
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 27 2017 at 11:36am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Jan 27, 2017 at 11:34:34AM -0500, Mike Snitzer wrote:
> > Noticed after further review that it seems a bit weird to have the non
> > blk-mq support in drivers calling blk_mq_rq_to_pdu().  But I'm not sure
> > a blk_rq_to_pdu() macro to blk_mq_rq_to_pdu() is the right thing.  What
> > do you guys think?
> 
> My first version had an additional name for it, but it caused more
> confusion than help.

And renaming blk_mq_rq_to_pdu() to blk_rq_to_pdu() tree-wide would be
too much churn?

I can live with blk_mq_rq_to_pdu(); just figured I'd ask.
