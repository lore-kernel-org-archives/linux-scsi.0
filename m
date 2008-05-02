From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 10:16:29 -0600
Message-ID: <20080502161629.GF14976@parisc-linux.org>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org> <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56591 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822AbYEBQQp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:16:45 -0400
Content-Disposition: inline
In-Reply-To: <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, May 02, 2008 at 06:06:59PM +0200, Bart Van Assche wrote:
> James Bottomley clearly expressed in that thread that he doesn't want
> to maintain two SCSI target frameworks. So what I propose is that SCST
> is included in the mainline and afterwards that it is evaluated
> whether or not it is desirable to keep other target code in the
> mainline kernel.

That's not the way it works, sorry.

The way to get SCST in is to work with the people who care about target
frameworks (which doesn't include me, fwiw).  You come to a consensus
about the way to proceed.  Normally this will be a gradual migration of
the good bits from SCST into the kernel.  In *exceptional* circumstances,
we've replaced one piece of infrastructure with another (eg wireless
midlayers), but those are by no means the preferred ways to go.

Let me just re-emphasise this bit.  You HAVE to work with the existing
people.  If you can't come to a common understanding, your code won't
get in.  Even if it's better.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
