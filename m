From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter on per device basis
Date: Thu, 26 Jun 2008 12:13:45 +0200
Message-ID: <20080626101345.GO20851@kernel.dk>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com> <20080616151328Q.fujita.tomonori@lab.ntt.co.jp> <6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com> <20080618051447L.fujita.tomonori@lab.ntt.co.jp> <48583074.8010909@redhat.com> <48584252.5030901@interlog.com> <48592233.6040408@redhat.com> <6cf6b73e0806260310n5988b59dycb0aeab3b0f5c930@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:19279 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYFZKNs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2008 06:13:48 -0400
Content-Disposition: inline
In-Reply-To: <6cf6b73e0806260310n5988b59dycb0aeab3b0f5c930@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: Peter Jones <pjones@redhat.com>, dgilbert@interlog.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, matthew@wil.cx, linux-scsi@vger.kernel.org

On Thu, Jun 26 2008, Adel Gadllah wrote:
> 2008/6/18 Peter Jones <pjones@redhat.com>:
> > Douglas Gilbert wrote:
> >>
> >> Peter Jones wrote:
> >>>
> >>> FUJITA Tomonori wrote:
> >>>
> >>>> Well, this changes sg behaviour since sg's allow_ops filter has a
> >>>> access permission different from blk_verify_command filter's.
> >>>
> >>>  >
> >>>>
> >>>> I guess that the first thing you need to do is that figuring out a
> >>>> proper access permission for each command, which sg maintainer, etc
> >>>> can agree. It's pretty hard and that's the reason why this patch has
> >>>> not been merged for years, I think.
> >>>
> >>> I don't think this logic is sound.
> >>
> >> That depends on your viewpoint.
> >
> > My viewpoint is this:
> >
> > 1) Whether you agree with his reasons or not, Linus made it pretty clear
> > that he's against removing the command filter (see
> > http://marc.info/?l=linux-scsi&m=115419945212450&w=2 )
> > 2) Having different code paths use different filtering code just adds more
> > confusion.
> > 3) If we're going to have filtering, it should be configurable on a
> > per-device basis from userland.
> >
> > Which of these do you disagree with?
> >
> > [...]
> >>
> >> Are per device command filters being proposed?
> >
> > Yes, that's what the patch implements.  And it allows the userland to
> > configure them according to the needs of the hardware.
> 
> Jens can we add merge this for .27 or does anyone still has objections?

Sure, I think it's a good idea. Personally I'd rather get rid of the
filter, but that isn't an option. So the next best thing is to make it
really per-device and exposed and tweakable. Thanks for picking up the
abandoned patch and updating it, I'll add it for 2.6.27.

-- 
Jens Axboe

