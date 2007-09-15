From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 18:23:13 +0200
Message-ID: <20070915162313.GV3563@stusta.de>
References: <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <20070915125055.GQ3563@stusta.de> <46EBDC06.3030202@s5r6.in-berlin.de> <20070915135314.GS3563@stusta.de> <46EBE821.2080300@s5r6.in-berlin.de> <20070915144341.GT3563@stusta.de> <46EBF9DC.1000503@s5r6.in-berlin.de> <46EBFDFB.5040401@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51092 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751585AbXIOQXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 12:23:03 -0400
Content-Disposition: inline
In-Reply-To: <46EBFDFB.5040401@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 11:44:59AM -0400, Jeff Garzik wrote:
> Stefan Richter wrote:
>> Adrian Bunk wrote:
>>> On Sat, Sep 15, 2007 at 04:11:45PM +0200, Stefan Richter wrote:
>>>> Perfect is in the eye of the beholder.  You would consequently have to
>>>> add such options into all menus which contain scsi low-level providers.
>>> Kconfig is a user interface, so perfect is what is best for the
>>> kconfig users.
>> Duplicate options with different names in different menus, but which all
>> do the same, --- is this the best for users?
>
> I recognize it's a rhetorical question :)  The answer is of course "no".
>
> I hope the other participants of this thread register the severe 
> disinclination of the maintainers to change this stuff, as this is a 
> classic case of making a mountain out of a molehill[1].
>
> For the -vast majority- of people configuring the kernel, this is not a 
> problem.  Kernel people are -expected- to know what they're doing, 

I doubt your claim is true since the vast majority of kconfig users
are most likely not kernel developers.

@Greg:
Do you have any numbers regarding how your "Linux Kernel in a Nutshell" 
is selling?
Even download numbers?

> especially when switching from one major subsystem to another.

It's not only about switching, the same problems awaits people when 
configuring a kernel for their hardware the first time.

> Therefore, all this is IMO wasted effort and hot air.  There are far more 
> important issues to deal with.

Why don't we dump kconfig and write the .config by hand?  ;-)

More seriously:
Yes, there are many other important issues in the kernel.
But not fixing kconfig UI problems doesn't fix these issues faster.

I have seen people running into problems because some required 
option wasn't set - in the simplest cases things like IDE without DMA 
because a help text wasn't updated when more hardware support was added 
to a driver.

You might not care about the kconfig users.
But other people do.

> 	Jeff
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

