From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: can't write to tape
Date: Thu, 27 Jan 2005 21:45:36 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0501272144270.5812@poirot.grange>
References: <200501060518.25782.andrex@alumni.utexas.net>
 <20050109125116.GA6293@twibble.org> <Pine.LNX.4.60.0501222356400.5769@poirot.grange>
 <200501262013.20664.andrex@alumni.utexas.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:44443 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261251AbVA0Wgh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 17:36:37 -0500
In-Reply-To: <200501262013.20664.andrex@alumni.utexas.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Schulman <andrex@alumni.utexas.net>
Cc: Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Wed, 26 Jan 2005, Andrew Schulman wrote:

> > > > I could try to improve the highmem situation / sg-handling. Or do you
> > > > plan to do it, Jamie?
> > >
> > > It's on my list of things to do, but I doubt I'll have any time to do
> > > anything about in the next few months. So if you have the time and
> > > desire please go ahead! I'll can test any changes you make (with a
> > > CD-R/W, tape-drive and HDD), although it may take me a week or two to
> > > get around to it.
> >
> > Ok, less than 2 weeks and here comes the first attempt. It removes
> > page_to_virt and maps sg lists dynamically. Please, review, test. Slightly
> > tested here - without highmem.
> 
> Guennadi and Jamie, thanks for your help on this.  However, I'm afraid I have 
> to bail out at this point.  My tape drive was the only reason I was keeping 
> my old DC395UW controller going, and it has now gone bad.  So I've had to 
> yank both the card and tape drive and install a different backup solution.  
> So, I can't test any patches.

Thanks for your help.

Guennadi
---
Guennadi Liakhovetski

