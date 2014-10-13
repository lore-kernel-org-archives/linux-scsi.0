From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 01/12] blk-mq: Use all available hardware queues
Date: Mon, 13 Oct 2014 11:45:43 +0200
Message-ID: <543B9F47.2090204@acm.org>
References: <5433E43D.3010107@acm.org> <5433E473.4020102@acm.org> <5433FA8F.3050100@kernel.dk> <54353A74.7040406@acm.org> <20141011111114.GB9593@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141011111114.GB9593-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/11/14 13:11, Christoph Hellwig wrote:
> On Wed, Oct 08, 2014 at 03:21:56PM +0200, Bart Van Assche wrote:
>> On 10/07/14 16:37, Jens Axboe wrote:
>>> Lets do this separate, as explained last time, it needs to be evaluated
>>> on its own and doesn't really belong in this series of patches.
>>
>> Hello Jens,
>>
>> A few minutes ago I have resent this patch to you with the LKML in CC. I
>> hope that Christoph agrees with leaving out this patch from this series
>> without me having to resend this series. BTW, Sagi promised me off-list to
>> review the other patches in this series.
>
> Ignoring patches is one of the easier tasks, np.  Do you want me to
> merge all the srp updates?  They normally go through the IB tree, but
> I can pick them up this time so that we don't need to synchronize the
> two trees.

Hello Christoph,

Since patch 1/12 already has been sent separately to Jens patches 
2/12..12/12 remain. The SRP initiator changes in this series depend on 
the blk-mq and scsi-mq features added in patches 2/12..4/12. I think we 
should avoid splitting these patches over multiple kernel trees to avoid 
having to deal with dependencies between kernel trees.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
