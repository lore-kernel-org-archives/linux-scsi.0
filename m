From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sat, 27 Jan 2018 21:03:12 -0500
Message-ID: <20180128020312.GA26437@redhat.com>
References: <20180123161613.14214-1-ming.lei@redhat.com>
 <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
 <20180127190920.GA24759@redhat.com>
 <1517091161.3055.7.camel@wdc.com>
 <20180128002356.GA25933@redhat.com>
 <1517100877.3055.23.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751588AbeA1CDT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 27 Jan 2018 21:03:19 -0500
Content-Disposition: inline
In-Reply-To: <1517100877.3055.23.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Sat, Jan 27 2018 at  7:54pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Sat, 2018-01-27 at 19:23 -0500, Mike Snitzer wrote:
> > Your contributions do _not_ make up for your inability to work well with
> > others.  Tiresome doesn't begin to describe these interactions.
> > 
> > Life is too short to continue enduring your bullshit.
> > 
> > But do let us know when you have something of substance to contribute
> > (hint: code talks).
> 
> Sorry Mike but what you wrote above is not only very gross but it is also
> wrong. What I did in my e-mail is to identify technical problems in Ming's
> work. Additionally, it seems like you forgot that recently I helped Ming?
> My patch "blk-mq: Avoid that blk_mq_delay_run_hw_queue() introduces
> unintended delays" has been queued by Jens for kernel v4.16 and solves a
> problem that Ming has been working on for two months but that he was
> unable to come up with a proper fix for. Additionally, there is something
> that you have to explain: the patch "dm mpath: don't call
> blk_mq_delay_run_hw_queue() in case of BLK_STS_RESOURCE" that you have
> queued in your tree is wrong and introduces a regression
> (https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=dm-4.16&id=316a795ad388e0c3ca613454851a28079d917a92).
> I'm surprised that you have not yet reverted that patch? BTW, in case you
> would not yet have noticed my patch "blk-mq: Avoid that
> blk_mq_delay_run_hw_queue() introduces unintended delays" eliminates the
> delay you referred to in the description of that patch.

You cannot even be forthcoming about the technical merit of a change you
authored (commit 6077c2d70) that I'm left to clean up in the face of
performance bottlenecks it unwittingly introduced?  If you were being
honest: you'd grant that the random delay of 100ms is utterly baseless
(not to mention that kicking the queue like you did is a complete
hack).  So that 100ms delay is what my dm-4.16 commit is talking about.
Not the fact that blk-mq wasn't using kblockd_mod_delayed_work_on().

Commit 6077c2d70 was wrong and never should've been introduced!  And you
even said that reintroducing commit 6077c2d70 didn't fix the regression
Ming's V3 fully corrects.  So why would I revert eliminating it exactly?

You aren't doing yourself any justice.  We're all smart enough to see
through your misdirection and labored attempt to cover your tracks.

In the past you've been very helpful with highly reasoned and technical
contributions.  But you get unhinged more often than not when it comes
to Ming's work.  That has made you one of the most duplicitous engineers
I've witnessed and had to deal with directly.  It is like Dr Jeykll and
Mr Hyde with you.

So I'm done treating you with kid gloves.  You are incapable of
responding favorably to subtle social queues or even outright pleas for
more productive behavior:
https://marc.info/?l=linux-scsi&m=151011037229460&w=2

Otherwise I wouldn't be having to respond to you right now!

> In case the above would not yet have addressed the technical issue(s) you
> are facing, I would really appreciate it if you would stop using insults and
> if you could explain what technical problems you are facing. Isn't that what
> the Linux kernel is about, namely about collaboration between technical
> people from different organizations? Isn't that what made the Linux kernel
> great?

Don't project onto me Bart.  This isn't the first time you've been
completely unprofessional and sadly it likely won't be the last.

Treat others how you want to be treated.  It really is that simple.
