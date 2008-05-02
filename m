From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 02 May 2008 11:30:09 -0500
Message-ID: <1209745809.3121.43.camel@localhost.localdomain>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <20080502161629.GF14976@parisc-linux.org>
	 <e2e108260805020923wc7a9e0bl539eaa386d8410bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36275 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762480AbYEBQaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:30:15 -0400
In-Reply-To: <e2e108260805020923wc7a9e0bl539eaa386d8410bb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, 2008-05-02 at 18:23 +0200, Bart Van Assche wrote:
> On Fri, May 2, 2008 at 6:16 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Fri, May 02, 2008 at 06:06:59PM +0200, Bart Van Assche wrote:
> >> James Bottomley clearly expressed in that thread that he doesn't want
> >> to maintain two SCSI target frameworks. So what I propose is that SCST
> >> is included in the mainline and afterwards that it is evaluated
> >> whether or not it is desirable to keep other target code in the
> >> mainline kernel.
> >
> > That's not the way it works, sorry.
> >
> > The way to get SCST in is to work with the people who care about target
> > frameworks (which doesn't include me, fwiw).  You come to a consensus
> > about the way to proceed.  Normally this will be a gradual migration of
> > the good bits from SCST into the kernel.  In *exceptional* circumstances,
> > we've replaced one piece of infrastructure with another (eg wireless
> > midlayers), but those are by no means the preferred ways to go.
> >
> > Let me just re-emphasise this bit.  You HAVE to work with the existing
> > people.  If you can't come to a common understanding, your code won't
> > get in.  Even if it's better.
> 
> Which target code is already in the mainline kernel, and who are the
> maintainers for this code ? I checked the MAINTAINERS file in the
> 2.6.25 tarball, but in this file I could not find the information I
> was looking for.

Um, you claimed to be running benchmarks against it in the thread you
just quoted to push for SCST inclusion.  If you genuinely don't know
which code is actually in the kernel, what exactly were the benchmarks
against?

James


