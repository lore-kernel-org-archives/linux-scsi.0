From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Bcache
Date: Thu, 15 Mar 2012 21:45:53 -0400
Message-ID: <20120316014552.GA24834@redhat.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
 <20120314220150.GA15464@redhat.com>
 <20120315172746.GC8638@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120315201732.GA23403@redhat.com>
 <20120315225952.GA8564@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab2CPBqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2012 21:46:09 -0400
Content-Disposition: inline
In-Reply-To: <20120315225952.GA8564@dhcp-172-18-216-138.mtv.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>

On Thu, Mar 15 2012 at  6:59pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> On Thu, Mar 15, 2012 at 04:17:32PM -0400, Mike Snitzer wrote:
> > Your interest should be in getting the hard work you've put into bcache
> > upstream.  That's unlikely to happen until you soften on your reluctance
> > to embrace existing appropriate kernel interfaces.
> 
> I don't really care what you think my priorities should be. I write code
> first and foremost for myself, and the one thing I care about is good
> code.
> 
> I'd love to have bcache in mainline, seeing more use and getting more
> improvements - but if that's contingent on making it work through dm,
> sorry, not interested.
> 
> If you want to convince me that dm is the right way to go you'll have
> much better luck with technical arguments.

We have quite a lot of code that illustrates how to implement DM
targets.  DM isn't forcing undue or cumbersome constraints that prevent
it's use for complex targets with in-kernel metadata -- again dm-thinp
proves this.

It is your burden to even begin to substantiate _why_ both DM and MD are
inadequate frameworks for virtual block device drivers.

> > Baseless and unspecific assertions don't help your cause -- dm-thinp
> > disproves your unconvincing position (manages it's metadata in kernel,
> > etc).
> 
> I'm not the only one who's read the dm code and found it lacking - and
> anyways, I'm not really out to convince anyone. 

Like other kernel code, DM is approachable for those who are willing to
put the time in to understand it.  Your hand-waving (and now proxy)
critiques leave us nothing to work with.

> > > Kind of presumptuous, don't you think?
> > 
> > Not really, considering what I'm responding to at the moment ;)
> 
> Maybe you should consider how you word things...

Say what?  Nice projection.  Luckily the thread is public for all to see.

I initially thought Christoph's feedback in this thread was harsh; now
it seems eerily prophetic.

Lets stop wasting our time on this thread.  Maybe we can be more
constructive in the future.
