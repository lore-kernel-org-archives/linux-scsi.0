From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: Kernel panic when re-inserting Adaptec PCMCIA card
Date: Mon, 19 Jun 2006 17:10:52 -0700
Message-ID: <20060619171052.916df694.rdunlap@xenotime.net>
References: <20060619233049.67325.qmail@web50205.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:20879 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S965004AbWFTAIG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jun 2006 20:08:06 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2006 17:08:04 -0700
In-Reply-To: <20060619233049.67325.qmail@web50205.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Davis <alex14641@yahoo.com>
Cc: 76306.1226@compuserve.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 19 Jun 2006 16:30:49 -0700 (PDT) Alex Davis wrote:

> --- Alex Davis <alex14641@yahoo.com> wrote:
> 
> > --- Chuck Ebbert <76306.1226@compuserve.com> wrote:
> > 
> > > In-Reply-To: <20060614022139.21737.qmail@web50208.mail.yahoo.com>
> > > 
> > > On Tue, 13 Jun 2006 19:21:39 -0700, Alex Davis wrote:
> > > 
> > > Same panic occurs in 2.6.17rc6:
> > > 
> > > > Jun 13 17:50:36 siafu kernel: [4295220.230000] pccard: PCMCIA card inserted into slot 0
> > > > Jun 13 17:50:36 siafu kernel: [4295220.230000] pcmcia: registering new device pcmcia0.0
> > > > Jun 13 17:50:37 siafu kernel: [4295220.281000] aha152x: resetting bus...
> > > > Jun 13 17:50:37 siafu kernel: [4295220.637000] aha152x13: vital data: rev=1, io=0xd340
> > > > (0xd340/0xd340), irq=3, scsiid=7, reconnect=enabled,
> > > >  parity=enabled, synchronous=enabled, delay=100, extended translation=disabled
> > > > Jun 13 17:50:37 siafu kernel: [4295220.637000] aha152x13: trying software interrupt, ok.
> > > > Jun 13 17:50:37 siafu kernel: [4295221.638000] scsi13 : Adaptec 152x SCSI driver; $Revision:
> > > 2.7 $
> > > > Jun 13 17:50:37 siafu kernel: [4295221.650000]
> > > > Jun 13 17:50:37 siafu kernel: [4295221.650000] aha152x22856: bottom-half already running!?
> > > > Jun 13 17:50:37 siafu kernel: [4295221.650000]
> > > > Jun 13 17:50:37 siafu kernel: [4295221.650000] queue status:
> > > > Jun 13 17:50:37 siafu kernel: [4295221.650000] issue_SC:
> > > > Jun 13 17:50:37 siafu kernel: [4295221.650000] current_SC:
> > > > Jun 13 17:50:37 siafu kernel: [4295221.650000] BUG: unable to handle kernel paging request
> > at
> > > > virtual address 00020016
> > > 
> > > Something is going very wrong here.  At time .637 it says it is
> > > adapter number 13 (aha152x13.)  Then at .650 it thinks it's
> > > adapter nr. 22856 (!)  Looks like some kind of pointer to the
> > > hostdata is corrupted.
> > > 
> > > Can you rmmod the driver after removing the card and see if that
> > > helps?
> > > 
> > It turns out I was trying to remove the driver before doing 'pccardctl eject'.
> > 
> > It seems that removing the driver after ejecting make the problem go away:
> > I ejected and re-inserted the card six times with no crash.
> > 
> > I'll continue testing just to make sure.
> > 
> Will removing the module after ejecting be considered the fix 
> for this problem??

That's a workaround IMO, not the proper fix.

---
~Randy
