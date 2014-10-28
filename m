From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/12] blk-mq: Add blk_mq_unique_tag()
Date: Mon, 27 Oct 2014 21:55:32 -0400
Message-ID: <yq1oasxot4b.fsf@sermon.lab.mkp.net>
References: <5433E43D.3010107@acm.org> <5433E493.9030304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5433E493.9030304-HInyCGIudOg@public.gmane.org> (Bart Van Assche's message of "Tue, 07
	Oct 2014 15:03:15 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi@vger.kernel.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> writes:

Bart> The queuecommand() callback functions in SCSI low-level drivers
Bart> need to know which hardware context has been selected by the block
Bart> layer. Since this information is not available in the request
Bart> structure, and since passing the hctx pointer directly to the
Bart> queuecommand callback function would require modification of all
Bart> SCSI LLDs, add a function to the block layer that allows to query
Bart> the hardware context index.

I agree with consolidating the two functions. Otherwise OK.

Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
