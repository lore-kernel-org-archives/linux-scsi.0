From: David Brownell <david-b@pacbell.net>
Subject: Re: usb storage traces
Date: Fri, 05 Dec 2003 10:24:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FD0CD41.6000408@pacbell.net>
References: <Pine.LNX.4.44L0.0312051049040.850-100000@ida.rowland.org>	 <1070640667.12411.32.camel@patibmrh9>  <3FD0BCED.2070205@pacbell.net> <1070645720.12411.212.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw6.prodigy.net ([64.164.98.56]:15323 "EHLO mtaw6.prodigy.net")
	by vger.kernel.org with ESMTP id S264260AbTLESQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 13:16:37 -0500
In-Reply-To: <1070645720.12411.212.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>

Pat LaVarre wrote:
>>>Wow, our lead FSG developer has no Linux USB _device_.
>>
>>Well, he does have the "dummy_hcd" which lets him test
>>on the same machine running the USB host ... I'll leave
>>it to experts to contrast that with CONFIG_SCSI_DEBUG.
> 
> 
> Ah.
> 
> Does that mean I likewise can test fsg with a PC...

I don't think you can test windows interop that way,
even with windows emulators.  But yes, you could test
it against usb-storage.  That whole stack is available
through the "gadget-2.6" tree ... give it a whirl!


