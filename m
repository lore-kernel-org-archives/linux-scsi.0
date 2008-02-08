From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 7 Feb 2008 19:24:58 -0800
Message-ID: <20080207192458.77ea0778.akpm@linux-foundation.org>
References: <1202432206.3171.53.camel@localhost.localdomain>
	<20080207184606.03b28a9c.akpm@linux-foundation.org>
	<1202440603.3171.72.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756811AbYBHDYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 22:24:46 -0500
In-Reply-To: <1202440603.3171.72.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>, dougg@torque.net

On Thu, 07 Feb 2008 21:16:43 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-02-07 at 18:46 -0800, Andrew Morton wrote:
> > On Thu, 07 Feb 2008 18:56:46 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > Quite a bit of this is fixing things broken previously (the advansys fix
> > > is still pending resolution, but I'll send it as an -rc fix when we have
> > > it).  There's the final elimination of all drivers that are esp based
> > > but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> > > the usual bunch of driver updates and the addition of a new enclosure
> > > services driver and the corresponding ULD.
> > 
> > Sob.  Can we please merge "Convert SG from nopage to fault"?  It has been
> > sent three times, the first time was Dec 5 last year and it has thus far
> > received the lead balloon treatment.  Despite my explicit request for
> > consideration last time I sent it
> > 
> > If there is no movement here then I have to carry the moderately intrusive
> > mm-remove-nopage.patch for another N months and we need to watch out for
> > new ->nopage implementations popping up etc.
> 
> I agree ... I've pinged Doug privately, this is publicly.
> Unfortunately, it is an intrusive change and needs testing .. I just
> don't have the tools that do this for SG.  
> 

I keep on forgetting that sg==dougg.

<looks in MAINTAINERS. Shifts blame.>

In fact scsi is the area in which I have the most who-maintains-what
trouble.  I just don't believe what MAINTAINERS says about scsi drivers and
I tend to resort to git-whatchanged to find out who's really doing stuff. 
The number of people@lsil.com makes my head spin and I tend to cc as many
as I can get my hands on.

IOW: some care and attention to the ./MAINTAINERS file would really help
here.

