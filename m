From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 01/12] blk-mq: Use all available hardware queues
Date: Fri, 17 Oct 2014 06:20:53 -0700
Message-ID: <20141017132053.GF16538@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E473.4020102@acm.org>
 <5433FA8F.3050100@kernel.dk>
 <54353A74.7040406@acm.org>
 <20141011111114.GB9593@infradead.org>
 <543B9F47.2090204@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <543B9F47.2090204-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 13, 2014 at 11:45:43AM +0200, Bart Van Assche wrote:
> Since patch 1/12 already has been sent separately to Jens patches
> 2/12..12/12 remain. The SRP initiator changes in this series depend on the
> blk-mq and scsi-mq features added in patches 2/12..4/12. I think we should
> avoid splitting these patches over multiple kernel trees to avoid having to
> deal with dependencies between kernel trees.

I'd like to pull it in and Roland already did indicate that he's fine
with it.

Sagi, can I get a review from you for the remaining SRP patches?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
