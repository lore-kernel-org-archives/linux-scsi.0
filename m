From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 12:42:52 -0400 (EDT)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0309221239460.636-100000@ida.rowland.org>
References: <Pine.LNX.4.44.0309220900440.1753-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44.0309220900440.1753-100000@home.osdl.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl
List-Id: linux-scsi@vger.kernel.org

On Mon, 22 Sep 2003, Linus Torvalds wrote:

> 
> [ Andries added to the cc ]
> 
> On Mon, 22 Sep 2003, Patrick Mansfield wrote:
> > 
> > I can modify the patch for that.
> 
> How about just making the sd.c layer more robust? That has worked well in 
> the past, and it seems wrong to have to add more and more flags.

<snip>

> Basically, Andries Brouwer's strategy of making sd.c more conservative has
> been a very successful one in the past. Why not continue on that?

I would be interested in hearing what Andries has to say.  But there has
been a large number of reports from users trying out various patches, and
it's clear that no single strategy will work with every device.  The
variety of ways in which these things fail is truly amazing.

Alan Stern



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
