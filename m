From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Fri, 20 Apr 2012 19:34:06 -0400
Message-ID: <20120420233406.GA11183@redhat.com>
References: <20111215214440.GA17677@redhat.com>
 <4EF039D5.5010201@suse.de>
 <20120405144721.GA18437@redhat.com>
 <20120420144538.GB8155@redhat.com>
 <20120420173405.GA8846@redhat.com>
 <20120420214120.159e2690@pyramind.ukuu.org.uk>
 <20120420215825.GA10406@redhat.com>
 <20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
 <20120420225822.GA10769@redhat.com>
 <20120421001433.2955abd4@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120421001433.2955abd4@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 20 2012 at  7:14pm -0400,
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Sure Alan, seize on "proprietary" and "EXPORT_SYMBOL_GPL".. and gloss
> > right over the fact that what is being proposed is reasonable.
> 
> I suggest you read the licence document.
> 
> > Any multipath driver should be able to detach a scsi_dh module.  As is
> > evidenced by the fact that they can already make use of sysfs to do so.
> 
> They can call the _GPL version if they are GPL, so there is no problem.
> 
> > Relaxing the scsi_dh_detach interface makes it easier for a long
> > standing proprietary driver to get out of Linux's way.
> 
> So we are back to this being for a proprietary driver trying to link with
> GPL code.
> 
> > _Upstream_ has kept it that way because we've been concerned about
> > breaking PowerPath in enterprises where Linux is deployed.  Upstream has
> > been good citizens to the fault of Linux.
> 
> Not from where I am standing. It sounds like upstream has suffered for
> the benefit of a dubious proprietary module.
> 
> > > I'm a rights holder. Domain expertise isn't relevant here. The code I
> > > provided is licensed under the GPL. Whether the symbol is EXPORT_SYMBOL
> > > or EXPORT_SYMBOL_GPL any derivative code (eg code that requires the
> > > kernel be modified to match it) cannot call it.
> > 
> > Remind me again when you ever developed anything to do with scsi_dh?
> 
> It's part of the same kernel. It's GPL code. You can take your own code
> and relicense it to be non GPL if you wish, but not mine nor Greg's nor
> anyone elses.

The scsi_dh maintainer (Chandra) acked the change.  Hannes, the author of
scsi_dh_attach, acked the change.  You don't have a leg to stand on.
Time for you to face that fact.

> > To be clear: PowerPath doesn't _need_ this.  Not even close.
> 
> Then we don't need to apply it ? Thank you for clarifying that.
> 
> > Linux is improved by not having to walk on egg shells that attaching a
> > helpful linux-only layer in kernel will somehow screw up some 3rd party
> > software that a customer values.
> 
> That's a problem for Red Hat. Don't dump it on upstream. If the kernel
> would work better with scsi_dh always attached we should always attach
> it. It's the problem of the out of tree people how they cope. They'll
> figure something out.
> 
> And you still have the same confusion
> 
> There is no "Linux only" magic in _GPL. Any derivative work of a GPL work
> must be distributed under the GPL.

You asserting something doesn't make it so.

> > You still don't get it... yet you'll saber rattle behind generic GPL
> > lawyer-up nonsense.
> 
> This has gone far enough but it seems your management has already jumped
> on it. Not my preferred way of handling such matters but Red Hat legal and
> PR need to rein you in before you cause some serious damage.

What the hell are you talking about?

Please stop the insanity.
