From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Fri, 24 Oct 2014 08:45:05 +0200
Message-ID: <5449F571.7080308@acm.org>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org> <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net> <5448AB4F.40507@acm.org> <54493E5A.7050803@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54493E5A.7050803-VXdhtT5mjnY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: webbnh-VXdhtT5mjnY@public.gmane.org, "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Don Brace (PMC)" <Don.Brace-PwyqCcigF0Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/23/14 19:43, Webb Scales wrote:
> On 10/23/14 3:16 AM, Bart Van Assche wrote:
>> All my tests with use_blk_mq=n were run with a WARN_ON_ONCE(req->tag <
>> 0) statement present in srp_queuecommand(). I haven't seen any kernel
>> warning being triggered during the tests I ran.
>
> Bart, what's the data type of "req->tag", here?  (E.g., if it
> "unsigned", it will never be less than zero, right?)

Hello Webb,

This is what I found in "struct request" in <linux/blkdev.h>:

struct request {
	[ ... ]
	int tag;
	[ ... ]
};

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
