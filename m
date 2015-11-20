From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Fri, 20 Nov 2015 12:40:03 +0100
Message-ID: <201511201240.03828.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <20151120100047.GA27842@infradead.org> <alpine.LNX.2.00.1511202138240.16424@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511202138240.16424@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 20 November 2015, Finn Thain wrote:
> 
> On Fri, 20 Nov 2015, Christoph Hellwig wrote:
> 
> > On Fri, Nov 20, 2015 at 07:19:21PM +1100, Finn Thain wrote:
> >
> > > Yes. I didn't do that conversion because I don't have ISA hardware and 
> > > I don't understand ISA probing.
> > > 
> > > The present patch set doesn't seek to resurrect the ISA drivers. But I 
> > > am trying to avoid regressions.
> > > 
> > > I have mixed feelings about the ISA drivers. ISA DMA support 
> > > complicates things (it was never completed) and DMA seems to be the 
> > > main obstacle to merging the two core driver forks.
> > 
> > I'd love to be able to get rid of the ISA drivers to be honest.
> 
> Is that because of their use of scsi_module.c or their general decrepitude 
> or something else?

scsi_module.c usage shouldn't be hard to fix. I can do that after finding a working setup.

> > Given that they appear to be gravely broken before your cleanups this 
> > might be an opportunity to get rid of them.
> 
> At this stage, that's unclear (to me). It could be that g_NCR5380.c is not 
> broken. It could be that the core driver can't handle certain targets. I 
> think we need to do more testing.

Maybe I was just unlucky and tested a drive that never worked with this driver.

Working ISA means more testing possibilities. It's much easier to get an ISA card than a Sun or Atari. Also faster CPU (such as 1 GHz P3) means quicker testing.

-- 
Ondrej Zary
