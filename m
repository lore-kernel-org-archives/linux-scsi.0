From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 05 Dec 2003 11:41:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070649674.12411.355.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312051309151.1013-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:65258 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264290AbTLESl0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 13:41:26 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312051309151.1013-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, David Brownell <david-b@pacbell.net>, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>

> You can indeed run FSG using the dummy_hcd driver under 
> Linux.  It's good enough for testing and seeing how things work.  If you 
> want more detailed instructions I'll send them later.

Yes please.

cc linux-scsi@vger.kernel.org of course would give us a google url we
can use thereafter.

> But you can't connect to another host.  dummy_hcd is strictly a "loopback"  
> adapter.  So FSG/dummy_hcd can talk to usb-storage but there's no way to
> hook it up to Windows (not even using VMWare).

True til the lk win emulators let us plug usb devices into win.  Truth
or slander, I hear Microsoft's Mac OS X Virtual PC can do this.

Pat LaVarre


