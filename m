From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 05 Dec 2003 10:35:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070645720.12411.212.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312051049040.850-100000@ida.rowland.org>
	 <1070640667.12411.32.camel@patibmrh9>  <3FD0BCED.2070205@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:2274 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264318AbTLERfc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 12:35:32 -0500
In-Reply-To: <3FD0BCED.2070205@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>

> > Wow, our lead FSG developer has no Linux USB _device_.
> 
> Well, he does have the "dummy_hcd" which lets him test
> on the same machine running the USB host ... I'll leave
> it to experts to contrast that with CONFIG_SCSI_DEBUG.

Ah.

Does that mean I likewise can test fsg with a PC, rather than having to
divine how to burn Linux into my 'once-free-with-msdn "ViewSonic"
"Pocket PC V37" whose Windows --> Settings --> System > --> About
reports "Intel PXA255" "36.45 MB"'?

Pat LaVarre

P.S. With CONFIG_SCSI_DEBUG as yet personally I have gotten no further
than finding it in `make xconfig` and changing the default off to =m.

