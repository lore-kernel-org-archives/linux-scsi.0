From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 11/12] IB/srp: Eliminate free_reqs list
Date: Mon, 20 Oct 2014 13:47:53 +0200
Message-ID: <5444F669.1020803@acm.org>
References: <5433E43D.3010107@acm.org> <5433E56E.6010600@acm.org> <20141017105939.GB7819@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141017105939.GB7819-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/17/14 12:59, Christoph Hellwig wrote:
> On Tue, Oct 07, 2014 at 03:06:54PM +0200, Bart Van Assche wrote:
>> The free_reqs list is no longer needed now that we are using
>> tags assigned by the block layer. Hence remove it.
>
> Is there any good reason not to fold this into the previous patch?

The only reason why patches 10/12 and 11/12 are separate patches
is to reduce the size of individual patches and hence to make it
easier to review these patches. If everyone agrees I'm fine with
folding patch 11/12 into patch 10/12.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
