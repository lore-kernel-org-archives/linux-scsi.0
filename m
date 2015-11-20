From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Fri, 20 Nov 2015 21:53:02 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511202138240.16424@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511181235.15663.linux@rainbow-software.org> <alpine.LNX.2.00.1511191321010.9967@nippy.intranet> <201511192350.58253.linux@rainbow-software.org> <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
 <alpine.LNX.2.00.1511201820130.14450@nippy.intranet> <20151120073354.GA26080@infradead.org> <alpine.LNX.2.00.1511201909540.15006@nippy.intranet> <20151120100047.GA27842@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151120100047.GA27842@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 20 Nov 2015, Christoph Hellwig wrote:

> On Fri, Nov 20, 2015 at 07:19:21PM +1100, Finn Thain wrote:
>
> > Yes. I didn't do that conversion because I don't have ISA hardware and 
> > I don't understand ISA probing.
> > 
> > The present patch set doesn't seek to resurrect the ISA drivers. But I 
> > am trying to avoid regressions.
> > 
> > I have mixed feelings about the ISA drivers. ISA DMA support 
> > complicates things (it was never completed) and DMA seems to be the 
> > main obstacle to merging the two core driver forks.
> 
> I'd love to be able to get rid of the ISA drivers to be honest.

Is that because of their use of scsi_module.c or their general decrepitude 
or something else?

> Given that they appear to be gravely broken before your cleanups this 
> might be an opportunity to get rid of them.

At this stage, that's unclear (to me). It could be that g_NCR5380.c is not 
broken. It could be that the core driver can't handle certain targets. I 
think we need to do more testing.

-- 
