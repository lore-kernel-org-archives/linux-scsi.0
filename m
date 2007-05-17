From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 15:30:43 -0600
Message-ID: <20070517213043.GN10562@parisc-linux.org>
References: <20070516025121.GK10562@parisc-linux.org> <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com> <20070517185115.GA13207@infradead.org> <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com> <20070517193953.GM10562@parisc-linux.org> <20070517194326.GC30571@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53042 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXEQVap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 17:30:45 -0400
Content-Disposition: inline
In-Reply-To: <20070517194326.GC30571@kvack.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org

On Thu, May 17, 2007 at 03:43:26PM -0400, Benjamin LaHaise wrote:
> On Thu, May 17, 2007 at 01:39:54PM -0600, Matthew Wilcox wrote:
> > On Fri, May 18, 2007 at 12:34:40AM +0530, Satyam Sharma wrote:
> > > Hmmm, actually those other users could easily write and maintain
> > > a 20-line patch that does the wait for async scans thing for them
> > > using /proc/scsi/scsi in any case.
> > 
> > How about the three users who're bothered by this extra module being
> > built maintain a one-line patch to Kconfig and leave well enough alone?
> 
> The module has an added bonus that it doesn't require any new tools to 
> make work.  Doing it via sysfs/procfs means a new rev of whatever tool 
> generates the boot initrd, plus fixing up boot scripts.  Loading a module 
> can be done via a simple option to the existing boot tools.

That was what James and I thought.  However, the distros seem unhappy
with it.  Of course, they won't actually *comment* on it, they just
disable the async scan and won't talk about why.

What's the point of this kernel-packagers list if not this kind of issue?
