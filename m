From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 03/12] scsi-mq: Add support for multiple hardware queues
Date: Wed, 29 Oct 2014 20:53:04 -0400
Message-ID: <yq1sii6l6of.fsf@sermon.lab.mkp.net>
References: <5433E43D.3010107@acm.org> <5433E4AB.8030306@acm.org>
	<yq1k33losu7.fsf@sermon.lab.mkp.net> <5450DC05.1010907@acm.org>
	<5450DD49.6090108@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5450DD49.6090108-HInyCGIudOg@public.gmane.org> (Bart Van Assche's message of "Wed, 29
	Oct 2014 13:27:53 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi@vger.kernel.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> writes:

Bart> Let me correct this: setting nr_hw_queues in the host template is
Bart> not yet supported. If anyone would consider this useful, such
Bart> functionality would be easy to add.

It seemed like an obvious thing a device driver would want to describe
in its host template. That's why I asked.

We can add it if somebody wants it but it's a bit of a chicken and egg
problem. Anyway. Minor issue.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
