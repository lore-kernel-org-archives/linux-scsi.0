From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 5/8] IB/srp: Remove stale connection retry mechanism
Date: Thu, 02 Oct 2014 12:34:36 +0200
Message-ID: <542D2A3C.2080009@acm.org>
References: <541C27BF.6070609@acm.org>	<541C287D.1050900@acm.org> <CAJ3xEMhPKiut4MwZH9F7-T0+u7B6XPuh-FTZpA=Xe4ViAj5UUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhPKiut4MwZH9F7-T0+u7B6XPuh-FTZpA=Xe4ViAj5UUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 09/20/14 19:45, Or Gerlitz wrote:
> On Fri, Sep 19, 2014 at 3:58 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> Attempting to connect three times may be insufficient after an
>> initiator system that was using multiple RDMA channels tries to
>> relogin. Additionally, this login retry mechanism is a workaround
>> for particular behavior of the IB/CM.
>
> Can you be more specific re the particular behavior of the IB CM?
> added Sean, the CM maintainer.

Let's focus on the software behavior instead of the people who are 
involved. What I have observed several times is that after a power cycle 
of the initiator system the first few login attempts are rejected. I was 
assuming that this was due to the IB/CM implementation but now that I 
have had another look at the logs I see that there is not enough 
information in the system logs to draw this conclusion. I will add 
additional logging statements in the initiator and target kernel code 
such that I can determine the root cause of this behavior.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
