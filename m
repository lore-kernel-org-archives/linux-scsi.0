From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Thu, 11 Sep 2008 15:15:43 -0700
Message-ID: <20080911221543.GQ66567@plap4-2.local>
References: <20080909143932.GA27117@orion.carnet.hr> <20080911113727.GA24487@orion.carnet.hr> <20080911215727.GA12885@orion.carnet.hr> <20080911.150150.256816031.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080911.150150.256816031.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: joy@entuzijast.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 11 Sep 2008, David Miller wrote:

> From: Josip Rodin <joy@entuzijast.net>
> Date: Thu, 11 Sep 2008 23:57:27 +0200
> 
> > On Thu, Sep 11, 2008 at 01:37:27PM +0200, Josip Rodin wrote:
> > > So I reviewed my steps and concluded that the only other thing different was
> > > adding ql2xextended_error_logging=1. I undid that change, rebuilt the
> > > initramfs image, and then the machine booted fine!
> > > 
> > > So, um, please fix the debugging code so that it doesn't cause more bugs... :/
> > > 
> > > In the meantime, I'll go back up to bed475c4cde5d12f537f445bdd0a5a3bb5684481
> > > and see how it does with the debugging patch.
> > 
> > The patch made it work, it seems.
> > 
> > I can also try it with the fully up to date git tree, or try new patches...?
> 
> Thanks for testing Josip.

Yes, thanks much, Josip!

> Andrew, please try to resolve the ql2xextended_error_logging problem Josip
> ran into,

I'll continue to look into this...

> as well as merge this IRQ enabling bug fix.

A candidate for rc-fixes, yes, as well as stable.  I'll post this fix
shortly...
