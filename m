From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Tue, 06 Apr 2004 09:16:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4072D7EB.1010105@pacbell.net>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>	<108109222			3.2034.8.camel@mulgrave>		<407050F4.2090607@pacbell.net>	<1081104161.2112.34.camel@mulgrave>		<4070D891.9040409@pacbell.net> <1081201463.2050.92.camel@mulgrave>		<4071EA82.3020901@pacbell.net> <1081214360.1756.330.camel@mulgrave> 	<4072C876.7030906@pacbell.net> <1081266433.1837.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw4.prodigy.net ([64.164.98.52]:28818 "EHLO mtaw4.prodigy.net")
	by vger.kernel.org with ESMTP id S263893AbUDFQQq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 12:16:46 -0400
In-Reply-To: <1081266433.1837.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
>>> that's intra subsystem synchronisation, not inter subsystem
>>
>>I'd say that device_driver.remove() calls from the bus management
>>code to a given device driver are inter-subsystem...
> 
> so using a subsystem provided API from another subsystem constitutes
> inter subsytem synchronisation?  I don't think so.

So it's now "I won't listen to those facts, they bother me" ...
Or maybe you're just trolling?  "From another subsystem" is
"between subsystems" is "inter-subsystem"; Q.E.D.

Either way, it's not worth the time to respond to you any more,
this will be my last post on this thread.


>>Refcounting systems need loop-breaking protocols ("disconnect");
>>this is needed for that sort of reason, if no other.
> 
> 
> No, they don't.

Without protocols for breaking referencing loops, systems that
use refcounting _alone_ (as you're advocating) leak memory unless
they prevent such loops ... but requests sent from one subsystem
to the next, then later returned, each embed such a loop.

That's in addition to the need for locking in certain paths,
on multi-threaded systems (like Linux).

(And for that matter, there were no WMDs in Iraq.)

Sorry for mentioning all those inconvenient facts;
I'll go away now.

