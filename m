From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 02 May 2008 11:18:04 -0500
Message-ID: <1209745084.3121.39.camel@localhost.localdomain>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56127 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935165AbYEBQSI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:18:08 -0400
In-Reply-To: <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, 2008-05-02 at 18:06 +0200, Bart Van Assche wrote:
> On Fri, May 2, 2008 at 5:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
> >> Regarding out-of-tree modules: this is just a preparatory step before
> >> submitting SCST for inclusion in the mainstream kernel.
> >
> > And what crackpipe did you smoke to thing we'd put duplicated target
> > framework in?
> 
> Why are you so aggressive ? I didn't insult you in any way.
> 
> Regarding inclusion of SCSI target code in the mainline, this subject
> has already been discussed extensively in the past
> (http://lkml.org/lkml/2008/1/23/134). The conclusion was clear: SCST
> is faster than any other existing iSCSI target for Linux (IET, STGT,
> LIO), stable, well maintained and the most standards compliant target.
> Why do you want to reopen this discussion ?

That's an interesting rewrite of history.  The evidence you presented
showed fairly identical results apart from on one contrived IB benchmark
that couldn't directly compare the two.

I'm also on record in the thread saying that was insufficient proof for
me to justify throwing STGT out and replacing it with SCST.

> James Bottomley clearly expressed in that thread that he doesn't want
> to maintain two SCSI target frameworks. So what I propose is that SCST
> is included in the mainline and afterwards that it is evaluated
> whether or not it is desirable to keep other target code in the
> mainline kernel.

That's hardly sufficient.  STGT is already in use.  Their either has to
be a migration path or, the preferred option, take the pieces of SCST
that are actual improvements and embed them in STGT.

James


