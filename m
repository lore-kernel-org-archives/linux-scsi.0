From: Adrian Bunk <bunk@kernel.org>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Fri, 14 Sep 2007 17:15:22 +0200
Message-ID: <20070914151522.GL3563@stusta.de>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43167 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754430AbXINPPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 11:15:12 -0400
Content-Disposition: inline
In-Reply-To: <46EAA08F.30703@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Sep 14, 2007 at 04:54:07PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Sun, Sep 09, 2007 at 05:11:44PM -0400, Jeff Garzik wrote:
> >> Let's step back a moment and consider the actual scale and impact of the 
> >> problem at hand.
> >>
> >> The vast majority of users are consumers of pre-compiled kernels, built by 
> >> People With Clue(tm), who figured this stuff out as soon as it was 
> >> introduced.
> [...]
> > In my experience, the vast majority of kconfig users are not the few 
> > people working on distribution kernels, most of the kconfig userbase 
> > could be better described by the use case "sysadmin who knows about the 
> > hardware in his machine and which filesystems he uses".
> 
> The patch which is discussed here is specifically targeted towards users
> who are convinced that they can migrate to different drivers without
> reading Kconfig help texts.

Nothing about the patch is only about migration.

The same applies if you configure a kernel from scratch.

Do "make menuconfig" with the .config you are normally using, count the 
number of options that are visible, and ask yourself whether we can 
really expect users to read the help texts for every single option shown.

People mostly read help texts for options where they don't understand 
what this option is about - and "Serial ATA" therefore is an option that 
is likely to get enabled without the user looking at the help text.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

