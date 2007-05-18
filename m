From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Asynchronous scsi scanning
Date: Fri, 18 May 2007 10:58:05 +0530
Message-ID: <a781481a0705172228j34e0b3eblade96458163475cb@mail.gmail.com>
References: <20070516025121.GK10562@parisc-linux.org>
	 <20070517172023.GL10562@parisc-linux.org>
	 <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
	 <20070517182414.GA12170@infradead.org>
	 <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
	 <20070517185115.GA13207@infradead.org>
	 <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com>
	 <20070517193953.GM10562@parisc-linux.org>
	 <20070517194326.GC30571@kvack.org>
	 <20070517213043.GN10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:25722 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbXERF2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2007 01:28:07 -0400
Received: by wx-out-0506.google.com with SMTP id h31so776899wxd
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2007 22:28:06 -0700 (PDT)
In-Reply-To: <20070517213043.GN10562@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Benjamin LaHaise <bcrl@kvack.org>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org

On 5/18/07, Matthew Wilcox <matthew@wil.cx> wrote:
> On Thu, May 17, 2007 at 03:43:26PM -0400, Benjamin LaHaise wrote:
> > On Thu, May 17, 2007 at 01:39:54PM -0600, Matthew Wilcox wrote:
> > > On Fri, May 18, 2007 at 12:34:40AM +0530, Satyam Sharma wrote:
> > > > Hmmm, actually those other users could easily write and maintain
> > > > a 20-line patch that does the wait for async scans thing for them
> > > > using /proc/scsi/scsi in any case.
> > >
> > > How about the three users who're bothered by this extra module being
> > > built maintain a one-line patch to Kconfig and leave well enough alone?

[ BTW, this is the last time I'll try explaining this to you. ]

The one-line patch you're suggesting *would*not*allow* one to use the async
scanning _at_all_. If one really wants to use async scanning reliably (even in
the future, as it can be turned on at boot-time later, like you very well know),
that module *must* be built. Making it user-visible and/or optional would *not*
be a solution but a *problem*. What I have been suggesting is *not* to make
this *dummy module* user-visible and/or optional but to _not_ use this
*dummy module* for this purpose in the first place.

[ There. What was this ... third ... fourth time? ]

> > The module has an added bonus that it doesn't require any new tools to
> > make work.  Doing it via sysfs/procfs means a new rev of whatever tool
> > generates the boot initrd, plus fixing up boot scripts.  Loading a module
> > can be done via a simple option to the existing boot tools.
>
> That was what James and I thought.  However, the distros seem unhappy
> with it.  Of course, they won't actually *comment* on it, they just
> disable the async scan and won't talk about why.

[ This time, I don't see the subject changing, nor a "change in the general
direction of the thread blah blah blah", and still you feel compelled to not
maintain the CC list. Wow. ]
