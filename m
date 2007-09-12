From: Adrian Bunk <bunk@kernel.org>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Thu, 13 Sep 2007 00:46:55 +0200
Message-ID: <20070912224655.GC3563@stusta.de>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60527 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751974AbXILWqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Sep 2007 18:46:47 -0400
Content-Disposition: inline
In-Reply-To: <46E46190.6080607@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Sep 09, 2007 at 05:11:44PM -0400, Jeff Garzik wrote:
> Andi Kleen wrote:
>>> I can see where you're coming from, but logically, this is wrong.
>>> There's a huge slew of enterprise machines that only have DVD on SATA.
>> ... and enterprise systems don't really care about a few KB more of code.
>> In fact you definitely want to have SATA compiled in in case you need
>> to recover the machine later when the SAN is down.
>>> On the other hand, all of these machines will have SCSI disk devices on
>>> various other transports, so no harm is done, it's just an inelegant
>>> solution.
>> Do you know of a better one?
>
> Let's step back a moment and consider the actual scale and impact of the 
> problem at hand.
>
> The vast majority of users are consumers of pre-compiled kernels, built by 
> People With Clue(tm), who figured this stuff out as soon as it was 
> introduced.

We are talking about a patch to kconfig, and the users using 
pre-compiled kernels are not kconfig users.

> The current setup expresses the dependencies as they exist -- OPTIONAL 
> extras, and that is a problem once a year or so, when someone builds their 
> own kernel but must learn this fact anew.
>
> There is simply no compelling need at all to change things from the current 
> setup.
>
> Our Kconfig system is for people who already know the kernel, not Aunt 
> Tillie.

Couldn't we just remove kconfig and assume that all "people who already 
know the kernel" anyway prefer to edit their .config using vi?  ;-)

In my experience, the vast majority of kconfig users are not the few 
people working on distribution kernels, most of the kconfig userbase 
could be better described by the use case "sysadmin who knows about the 
hardware in his machine and which filesystems he uses".

And there must have been a reason why a leading kernel developer has 
written a complete book covering only configuration and building of the
kernel - the target audience of this book are most likely not "people 
who already know the kernel".

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

