From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic79xx bug? my stupidity?
Date: Sun, 05 Jan 2003 18:46:33 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <14900000.1041817593@aslan.scsiguy.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
 <1041166487.1338.1.camel@laptop.fenrus.com>
 <610650816.1041607684@aslan.scsiguy.com>
 <200301052040.54974.robertopeon@sportvision.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200301052040.54974.robertopeon@sportvision.com>
Content-Disposition: inline
To: Roberto Peon <robertopeon@sportvision.com>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> I'm not sure to whom I should be addressing this, but it seems that
> Justin Gibbs is one of those people.

I wrote the aic79xx driver.

> I've been trying to get the aic79xx driver working in 2.4.19 without
> success. I'll clarify:

Which version?

> I've gotten far enough that I can get the kernel to boot with it, and it
> seems to see the controller, however, I cannot get it to find the root
> partition.

Does it see the disk where the root partition resides?  If you boot
off of IDE or some other device, can you perform I/O to this disk?

> From what I could find on the archives, it seemed like a patch might be
> needed to get a vanilla kernel up&running with the aic79xx driver. Is this
> right? If so, where might that patch be?

I don't know of any changes outside of adding the driver and adjusting the
Makefiles that are required.

> I have more questions and possibly a bug, but would like to find the
> proper people to speak with before burdening the list with tons of data.

You can just send the info to me.  If it's not my bug I'll redirect you
to the list.

--
Justin
