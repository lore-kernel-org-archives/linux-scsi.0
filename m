From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Fri, 5 Dec 2003 13:21:19 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312051309151.1013-100000@ida.rowland.org>
References: <1070645720.12411.212.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:25604 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264305AbTLESVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 13:21:19 -0500
In-Reply-To: <1070645720.12411.212.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: David Brownell <david-b@pacbell.net>, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>

On 5 Dec 2003, Pat LaVarre wrote:

> > > Wow, our lead FSG developer has no Linux USB _device_.
> > 
> > Well, he does have the "dummy_hcd" which lets him test
> > on the same machine running the USB host ... I'll leave
> > it to experts to contrast that with CONFIG_SCSI_DEBUG.
> 
> Ah.
> 
> Does that mean I likewise can test fsg with a PC, rather than having to
> divine how to burn Linux into my 'once-free-with-msdn "ViewSonic"
> "Pocket PC V37" whose Windows --> Settings --> System > --> About
> reports "Intel PXA255" "36.45 MB"'?

Well, sort of.  You can indeed run FSG using the dummy_hcd driver under 
Linux.  It's good enough for testing and seeing how things work.  If you 
want more detailed instructions I'll send them later.

But you can't connect to another host.  dummy_hcd is strictly a "loopback"  
adapter.  So FSG/dummy_hcd can talk to usb-storage but there's no way to
hook it up to Windows (not even using VMWare).

Alan Stern

