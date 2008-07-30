From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Problems building 2.6.26 and 2.6.27-rc1
Date: Wed, 30 Jul 2008 22:32:34 +0200
Message-ID: <20080730203234.GB12148@uranus.ravnborg.org>
References: <20080730184833.GA936@roadking.ldev.net> <adaiqunyyxd.fsf@cisco.com> <0F5B06BAB751E047AB5C87D1F77A778826B3E811B0@GVW0547EXC.americas.hpqcorp.net> <20080730201754.GA10882@uranus.ravnborg.org> <0F5B06BAB751E047AB5C87D1F77A778826B3E811D7@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout3.tre.se ([80.251.192.228]:17909 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYG3Ub7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 16:31:59 -0400
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3E811D7@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

On Wed, Jul 30, 2008 at 08:21:11PM +0000, Miller, Mike (OS Dev) wrote:
> Sam wrote:
> 
> >
> > On Wed, Jul 30, 2008 at 08:07:28PM +0000, Miller, Mike (OS Dev) wrote:
> > > Roland wrote:
> > >
> > > >
> > > >  > I'm getting the following error when trying to build either
> > > > 2.6.26 or  > 2.6.27-rc1:
> > > >  >
> > > >  > arch/x86/kernel/head64.c: In function 'x86_64_start_kernel':
> > > >  > arch/x86/kernel/head64.c:88: error: size of array
> > 'type name' is
> > > > negative
> > > >
> > > > It looks like you're hitting
> > > >
> > > >         BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
> > > >
> > > > No idea why you're hitting that though.  What's your .config and
> > > > compiler?
> > > >
> > > I think maybe I've figured out what's breaking my build. If
> > use "make -jN" I hit the error. I usually set N to the number
> > of processors (real and HT). So if /proc/cpuinfo display info
> > about 4 processors I use -j4, etc. If I don't specify the
> > number of jobs to run simultaneously the build completes with
> > just the usual warnings.
> > >
> > > Any experts on parallelism out there?
> >
> > Can you post the output of a make -j4 V=1 run that fials and
> > one that succeeds.
> > Then we can maybe spot something.
> >
> >         Sam
> Sure. Not to be stupid, but do you want the entire output from the builds or just what would go to stderr?

Entire output please.

	Sam
