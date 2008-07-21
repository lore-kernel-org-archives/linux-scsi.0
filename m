From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Mon, 21 Jul 2008 09:38:36 +0900
Message-ID: <4883DA8C.5030306@gmail.com>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com>	<20080719004736.626ef169@mjolnir.drzeus.cx>	<48813C5F.70007@gmail.com>	<20080719033050.552f9b49@mjolnir.drzeus.cx>	<48814D81.8060001@gmail.com>	<20080719140717.7b296eae@mjolnir.drzeus.cx>	<4881F437.7000503@gmail.com> <20080721004033.1fc66aa3@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080721004033.1fc66aa3-OhHrUh4vRMSnewYJFaQfwJ5kstrrjoWp@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pierre Ossman <drzeus-p3sGCRWkH8CeZLLa646FqQ@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-ide <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, tino.keitel-Mmb7MZpHnFY@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello, Pierre.

Pierre Ossman wrote:
> I've converted my code to use your implementation instead, and it seems
> to be working perfectly.

Cool.

> How comfortable to you feel about your patch? :)

I think it should be okay (well, of course :-) and tested a few corner
cases by modifying the copy function.

> This fixes a big problem in the sdhci driver where falling back on PIO
> (because of hw DMA bugs) would create lots of potential issues as the
> driver couldn't access highmem pages. I'd like to get this fix in for
> 2.6.27, which means that your patch also needs to go in now.

I think it needs an ACK from Jens.  Jens?

-- 
tejun
