From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Fri, 20 Nov 2015 03:45:15 -0800
Message-ID: <20151120114515.GA4651@infradead.org>
References: <20151118083455.331768508@telegraphics.com.au>
 <20151120100047.GA27842@infradead.org>
 <alpine.LNX.2.00.1511202138240.16424@nippy.intranet>
 <201511201240.03828.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201511201240.03828.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, Christoph Hellwig <hch@infradead.org>, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 20, 2015 at 12:40:03PM +0100, Ondrej Zary wrote:
> > > I'd love to be able to get rid of the ISA drivers to be honest.
> > 
> > Is that because of their use of scsi_module.c or their general decrepitude 
> > or something else?
> 
> scsi_module.c usage shouldn't be hard to fix. I can do that after finding a working setup.

It's the general state of them.

> 
> > > Given that they appear to be gravely broken before your cleanups this 
> > > might be an opportunity to get rid of them.
> > 
> > At this stage, that's unclear (to me). It could be that g_NCR5380.c is not 
> > broken. It could be that the core driver can't handle certain targets. I 
> > think we need to do more testing.
> 
> Maybe I was just unlucky and tested a drive that never worked with this driver.
> 
> Working ISA means more testing possibilities. It's much easier to get an ISA card than a Sun or Atari. Also faster CPU (such as 1 GHz P3) means quicker testing.


Well, if you volunteer to bring the NCR5380 ISA drivers up to date and
maintain them it's obvuously fine to keep them around.

I'm more worried about all the unmaintained ISA drivers in horrible
shape.
