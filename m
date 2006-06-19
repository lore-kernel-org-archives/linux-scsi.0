From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Kernel panic when re-inserting Adaptec PCMCIA card
Date: Mon, 19 Jun 2006 06:19:36 -0700 (PDT)
Message-ID: <20060619131936.19682.qmail@web50211.mail.yahoo.com>
References: <200606190600_MC3-1-C2D8-23E6@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web50211.mail.yahoo.com ([206.190.39.175]:36251 "HELO
	web50211.mail.yahoo.com") by vger.kernel.org with SMTP
	id S932447AbWFSNTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jun 2006 09:19:38 -0400
In-Reply-To: <200606190600_MC3-1-C2D8-23E6@compuserve.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

--- Chuck Ebbert <76306.1226@compuserve.com> wrote:

> In-Reply-To: <20060614022139.21737.qmail@web50208.mail.yahoo.com>
> 
> On Tue, 13 Jun 2006 19:21:39 -0700, Alex Davis wrote:
> 
> Same panic occurs in 2.6.17rc6:
> 
> > Jun 13 17:50:36 siafu kernel: [4295220.230000] pccard: PCMCIA card inserted into slot 0
> > Jun 13 17:50:36 siafu kernel: [4295220.230000] pcmcia: registering new device pcmcia0.0
> > Jun 13 17:50:37 siafu kernel: [4295220.281000] aha152x: resetting bus...
> > Jun 13 17:50:37 siafu kernel: [4295220.637000] aha152x13: vital data: rev=1, io=0xd340
> > (0xd340/0xd340), irq=3, scsiid=7, reconnect=enabled,
> >  parity=enabled, synchronous=enabled, delay=100, extended translation=disabled
> > Jun 13 17:50:37 siafu kernel: [4295220.637000] aha152x13: trying software interrupt, ok.
> > Jun 13 17:50:37 siafu kernel: [4295221.638000] scsi13 : Adaptec 152x SCSI driver; $Revision:
> 2.7 $
> > Jun 13 17:50:37 siafu kernel: [4295221.650000]
> > Jun 13 17:50:37 siafu kernel: [4295221.650000] aha152x22856: bottom-half already running!?
> > Jun 13 17:50:37 siafu kernel: [4295221.650000]
> > Jun 13 17:50:37 siafu kernel: [4295221.650000] queue status:
> > Jun 13 17:50:37 siafu kernel: [4295221.650000] issue_SC:
> > Jun 13 17:50:37 siafu kernel: [4295221.650000] current_SC:
> > Jun 13 17:50:37 siafu kernel: [4295221.650000] BUG: unable to handle kernel paging request at
> > virtual address 00020016
> 
> Something is going very wrong here.  At time .637 it says it is
> adapter number 13 (aha152x13.)  Then at .650 it thinks it's
> adapter nr. 22856 (!)  Looks like some kind of pointer to the
> hostdata is corrupted.
> 
> Can you rmmod the driver after removing the card and see if that
> helps?
> 
> -- 
> Chuck
>  "You can't read a newspaper if you can't read."  --George W. Bush

I can't rmmod the driver. The error message says it's in use.


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
