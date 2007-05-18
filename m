From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning
Date: Fri, 18 May 2007 05:24:37 -0600
Message-ID: <20070518112437.GQ10562@parisc-linux.org>
References: <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com> <20070517185115.GA13207@infradead.org> <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com> <20070517193953.GM10562@parisc-linux.org> <20070517194326.GC30571@kvack.org> <20070517213043.GN10562@parisc-linux.org> <a781481a0705172228j34e0b3eblade96458163475cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58578 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbXERLYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2007 07:24:38 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0705172228j34e0b3eblade96458163475cb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org

On Fri, May 18, 2007 at 10:58:05AM +0530, Satyam Sharma wrote:
> [ BTW, this is the last time I'll try explaining this to you. ]

Oh good.  Perhaps you can just drop the idea entirely and give up?

> The one-line patch you're suggesting *would*not*allow* one to use the async
> scanning _at_all_. If one really wants to use async scanning reliably (even 
> in
> the future, as it can be turned on at boot-time later, like you very well 
> know),
> that module *must* be built. Making it user-visible and/or optional would 
> *not*
> be a solution but a *problem*. What I have been suggesting is *not* to make
> this *dummy module* user-visible and/or optional but to _not_ use this
> *dummy module* for this purpose in the first place.

That's simply not true.  There are other ways of using async scanning
reliably -- as Peter Jones pointed out.  If you're relying on the earlier
semantics of "modprobe returned, therefore scanning is complete", then
yes, it's unreliable.  But if you're using kevents/udev/etc to find out
when devices have been discovered, then it's not unreliable.

> [ This time, I don't see the subject changing, nor a "change in the general
> direction of the thread blah blah blah", and still you feel compelled to not
> maintain the CC list. Wow. ]

I see trimming the CC list as a courtesy to those who've had enough of
this pointless thread landing in their mailboxes.
