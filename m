From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 18:52:42 +0200
Message-ID: <200709151852.43157.bzolnier@gmail.com>
References: <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <46EBFDFB.5040401@garzik.org> <20070915162313.GV3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:2702 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbXIOQwP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 12:52:15 -0400
Received: by nf-out-0910.google.com with SMTP id g13so872699nfb
        for <linux-scsi@vger.kernel.org>; Sat, 15 Sep 2007 09:52:14 -0700 (PDT)
In-Reply-To: <20070915162313.GV3563@stusta.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Greg Kroah-Hartman <gregkh@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

On Saturday 15 September 2007, Adrian Bunk wrote:
> On Sat, Sep 15, 2007 at 11:44:59AM -0400, Jeff Garzik wrote:
> > Stefan Richter wrote:
> >> Adrian Bunk wrote:
> >>> On Sat, Sep 15, 2007 at 04:11:45PM +0200, Stefan Richter wrote:
> >>>> Perfect is in the eye of the beholder.  You would consequently have to
> >>>> add such options into all menus which contain scsi low-level providers.
> >>> Kconfig is a user interface, so perfect is what is best for the
> >>> kconfig users.
> >> Duplicate options with different names in different menus, but which all
> >> do the same, --- is this the best for users?
> >
> > I recognize it's a rhetorical question :)  The answer is of course "no".
> >
> > I hope the other participants of this thread register the severe 
> > disinclination of the maintainers to change this stuff, as this is a 
> > classic case of making a mountain out of a molehill[1].
> >
> > For the -vast majority- of people configuring the kernel, this is not a 
> > problem.  Kernel people are -expected- to know what they're doing, 
> 
> I doubt your claim is true since the vast majority of kconfig users
> are most likely not kernel developers.

Yes, we shouldn't be needlessly raising the bar for power users.

> @Greg:
> Do you have any numbers regarding how your "Linux Kernel in a Nutshell" 
> is selling?
> Even download numbers?
> 
> > especially when switching from one major subsystem to another.
> 
> It's not only about switching, the same problems awaits people when 
> configuring a kernel for their hardware the first time.

*nods*

> > Therefore, all this is IMO wasted effort and hot air.  There are far more 
> > important issues to deal with.
> 
> Why don't we dump kconfig and write the .config by hand?  ;-)
> 
> More seriously:
> Yes, there are many other important issues in the kernel.
> But not fixing kconfig UI problems doesn't fix these issues faster.

Agreed, and actually not fixing Kconfig UI problems will make the other
issues being fixed *slower* (because they result in *increased* workload
on developers' side).

> I have seen people running into problems because some required 
> option wasn't set - in the simplest cases things like IDE without DMA 
> because a help text wasn't updated when more hardware support was added 
> to a driver.

This is why nowadays IDE DMA support is automatically selected by IDE
host drivers that need it - a big relief for everybody.

> You might not care about the kconfig users.
> But other people do.

...and even if their attempts/solutions may not be proper yet they should
not be discouraged to work on these problems...

Thanks,
Bart
