From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 10 Oct 2014 13:16:23 -0700
Message-ID: <CAL1RGDXTpAvwrgRvfLh4J+-+2LiOvDpRngQAVBRmvLdKmoY_CA@mail.gmail.com>
References: <541C27BF.6070609@acm.org> <541C28E0.7010705@acm.org>
 <CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>
 <541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>
 <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk> <542C270B.5020002@acm.org>
 <542C31C4.1020702@kernel.dk> <542D8143.3050305@acm.org> <20141002173044.GB25437@infradead.org>
 <54327A21.6070202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54327A21.6070202-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 6, 2014 at 4:16 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 10/02/14 19:30, Christoph Hellwig wrote:
>> Also if we want to merge scsi LLDDs that can take advantage of
>> multiqueue support it would probably be best if I take this via the SCSI
>> tree.

> Sending these patches to you is fine with me, at least if Roland agrees.

That's fine with me.  Christoph/Bart should I just let you guys handle
all the pending SRP patches, or is there anything I should pick up via
the InfiniBand tree?

Everything that's in flight looks reasonable to me, so I'm fine with
however you guys want to merge it.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
