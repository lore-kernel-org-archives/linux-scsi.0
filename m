From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 19 Dec 2003 09:21:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071850889.6191.26.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312190945170.805-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:50613 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263453AbTLSQV7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2003 11:21:59 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312190945170.805-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>

> The URL for my traces is:
> http://www.win.tue.nl/~aeb/linux/usb/traces/winme/

Thank you!

> ... doesn't show up in the default directory listing ...
> http://www.win.tue.nl/~aeb/linux/usb/traces/winme/README.txt

To the wish list for RMB please add:

Traces of disk absent (not just traces of disk present).

> One interesting thing about Windows ME
> stands out from reading the files:
> It seems to think the right way to recover
> from a "device was reset" response is to reset the device twice!

On my second reading I guess we here mean to be speaking of sk asc x 6
29.  I agree, silly to respond to a notification of reset received by
sending another reset.

On my first reading I wrongly guessed we here were speaking of some
other kind of trouble, to which I answered:

Why should this surprise us?

Reset, like any i/o operation, may fail.  Hosts that live by
"be liberal in what you accept" time out and retry resets, yes.  In
particular, by trying twice we more liberally tolerate those apparently
generic devices that in fact occasionally choose to scramble the status
phase data toggle at the end of a class-specific reset.  Naive hosts see
that as indefinite NAK.

Pat LaVarre
http://plavarre.blog-city.com/index.cfm?d=19&m=12&y=2003


