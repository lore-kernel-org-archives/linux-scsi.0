From: Adrian Bunk <bunk@kernel.org>
Subject: Re: Scsi on sparc build break in 2.6.23.
Date: Thu, 11 Oct 2007 17:21:49 +0200
Message-ID: <20071011152149.GZ16424@stusta.de>
References: <200710110552.49129.rob@landley.net> <20071011110555.GV16424@stusta.de> <200710110817.22344.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47205 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755604AbXJKPVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 11:21:22 -0400
Content-Disposition: inline
In-Reply-To: <200710110817.22344.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 08:17:22AM -0500, Rob Landley wrote:
> On Thursday 11 October 2007 6:05:55 am Adrian Bunk wrote:
> > On Thu, Oct 11, 2007 at 05:52:48AM -0500, Rob Landley wrote:
> > > CONFIG_SCSI_SUNESP=y breaks the build in 2.6.23:
> > >
> > >   LD      vmlinux
> > > `scsi_esp_unregister' referenced in section `__ksymtab' of
> > > drivers/built-in.o: defined in discarded section `.exit.text' of
> > > drivers/built-in.o
> > > make: *** [vmlinux] Error 1
> > >
> > > Do you need my full .config to reproduce this?
> >
> > Please always attach the .config when reporting errors.
> > The few bytes don't matter and it often saves some time.
> >
> > I have an idea regarding what might be going wrong in this case,
> > but it would cost me additional time to look at it because you didn't
> > send your .config.
> 
> *shrug*  That's why I asked.
> 
> The reason I hesitated is I use miniconfig files rather than big .config 
> files, and some people get confused by that.  Drop the attached 
> miniconfig-linux in the kernel source directory and go:
>   make ARCH=sparc allnoconfig KCONFIG_ALLCONFIG=miniconfig-linux
>...

I assume you have the full .config in your build directory, and could 
have taken it from there?

> Rob

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

