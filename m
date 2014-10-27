From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Mon, 27 Oct 2014 11:15:16 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1410271106570.15729@nippy.intranet>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065633.766165263@telegraphics.com.au> <5444BAB7.5000908@gmail.com> <alpine.LNX.2.00.1410202217270.18012@nippy.intranet> <544CA4A1.6050802@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <544CA4A1.6050802@gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org


On Sun, 26 Oct 2014, Michael Schmitz wrote:

> > On Mon, 20 Oct 2014, Michael Schmitz wrote:
> >
> > > not certain it is related to this exact patch - the driver crashes 
> > > pretty much on the spot when selecting the first target on the bus.
> > >     
> > ...
> 
> Turns out I missed a reject in patch 29 of the series (hunk #4) which 
> caused a local_irq_save(flags) to go AWOL. Both commenting out the 
> resulting lone local_irq_restore(flags), as well as fixing the reject 
> properly makes the driver behave as it should.
> 
> No locking races, and no more warnings about bytes stuck in the DMA 
> fifo. We might be on to a winner here :-)

That's good to hear. Thanks for testing v1. I'll send v2 when I'm done 
testing it.

-- 
