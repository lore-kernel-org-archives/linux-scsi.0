From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: 06 Apr 2004 09:03:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081260215.1804.17.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org>
	<4071EA82.3020901@pacbell.net> <1081214360.1756.330.camel@mulgrave>
	<200404060852.34169.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:22452 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263832AbUDFOEY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 10:04:24 -0400
In-Reply-To: <200404060852.34169.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: David Brownell <david-b@pacbell.net>, Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-04-06 at 01:52, Oliver Neukum wrote:
> Pure refcounting can never protect you against races with freeing objects.
> The counters themselves must be protected. Try as you might you need
> locks for that and rules on how this locks are to be used.

Which part of

On Mon, 2004-04-05 at 20:19, James Bottomley wrote:
> Now, if the subsystem is going to garbage collect its own object as a
> result of the other object disconnect, then it is responsible for
> synchronising that with reference gets on its own object.  However, that
> is easily achievable via *intra* subsystem synchronisation.

didn't you understand?

However, how a subsystem resolves this intra subsystem synchronisation
is up to it ... and it doesn't have to do it with locks.  So there are
no exposed locks for this and no rules therefore, for how to use them.

James


