From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Thu, 2 Oct 2014 10:30:44 -0700
Message-ID: <20141002173044.GB25437@infradead.org>
References: <541C27BF.6070609@acm.org>
 <541C28E0.7010705@acm.org>
 <CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>
 <541C49EC.6030404@acm.org>
 <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>
 <541C4D2F.9060907@acm.org>
 <541C4DF1.4090604@kernel.dk>
 <542C270B.5020002@acm.org>
 <542C31C4.1020702@kernel.dk>
 <542D8143.3050305@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <542D8143.3050305-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 06:45:55PM +0200, Bart Van Assche wrote:
> Would it be acceptable to let blk_mq_rq_tag() always return the
> hardware context number and the per-hctx tag ? Block and SCSI LLD 
> drivers that do not need the hardware context number can still use 
> rq->tag. Drivers that need both can use blk_mq_rq_tag(). That way we do 
> not have to introduce a new queue flag. How about the patch below 
> (which is still missing a BLK_MQ_MAX_DEPTH check):

I'd add the unique_ part to the name that Jens added, and fix up the
comment to be valid kerneldoc, but otherwise this looks fine to me.

Also if we want to merge scsi LLDDs that can take advantage of
multiqueue support it would probably be best if I take this via the SCSI
tree.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
