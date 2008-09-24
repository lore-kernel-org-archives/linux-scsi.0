From: David Miller <davem@davemloft.net>
Subject: Re: qlogicpti driver hangs the machine
Date: Tue, 23 Sep 2008 21:53:02 -0700 (PDT)
Message-ID: <20080923.215302.152506074.davem@davemloft.net>
References: <20080923155917.GE27204@parisc-linux.org>
	<20080923.212513.184633012.davem@davemloft.net>
	<20080924044211.GL27204@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20080924044211.GL27204@parisc-linux.org>
Sender: sparclinux-owner@vger.kernel.org
To: matthew@wil.cx
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Tue, 23 Sep 2008 22:42:11 -0600

> On Tue, Sep 23, 2008 at 09:25:13PM -0700, David Miller wrote:
> > From: Matthew Wilcox <matthew@wil.cx>
> > Date: Tue, 23 Sep 2008 09:59:18 -0600
> > 
> > > On Tue, Sep 23, 2008 at 06:06:03PM +0300, Meelis Roos wrote:
> > > > I tried to use Qlogic wide SE SCSI SBus controllers. First tied one in 
> > > > Sparcstation 5 (sparc32) with etch and sarge installers, then tried 
> > > > another in E3500. Both tries on SS5 hung when loadin qlogicpti module. 
> > > > E3500 conf doesn't autoload SBus drivers and the card was properly 
> > > > inserted only after installation, so I tried to modprobe qlogicpti after 
> > > > booting up. This also results in a hang but outputs that much on console 
> > > > before hanging. Maybe the error handling spinlock lockup gives a clue to 
> > > > someone...
> > > 
> > > What kernel version is this trace from?
> > 
> > FWIW, I personally haven't tested this driver in a long time, did
> > anyone give it at least a simple test when you made those
> > ->slave_configure changes to this driver?
> 
> Not that I know of, but I do have an incriminating email from you where
> you promise to pick up the pieces if anything explodes ;-)

And here I am :-)

> There've also been commits from Jens, Boaz and Tomo that could plausibly
> be related (I think we can discount the one from Adrian).  Meelis, can
> you run through the various patches to qlogicpti, backing them out one
> at a time?  I worry that some infrastructure may have been taken away by
> followups to these patches, so it may not be feasible.

I know, I looked at those too.  Backing many of them out is infeasible,
especially the scatterlist ones.

I'm about to stick a qlogicpti card into my ultra2 and try to reproduce
this.
