From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [example PATCH - not for applying] exclude
 certain commands
Date: Thu, 24 Apr 2003 17:09:16 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304241704460.1300-100000@ida.rowland.org>
References: <1051215651.1754.71.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:47108 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264439AbTDXU5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 16:57:06 -0400
In-Reply-To: <1051215651.1754.71.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, mike@hingston.demon.co.uk, stelian@popies.net

On 24 Apr 2003, James Bottomley wrote:

> On Thu, 2003-04-24 at 15:14, Matthew Dharm wrote:
> > Well, at this point, I guess I should just be happy that something is being
> > done.  But, what I'm really afraid of, this coming right back to this
> > point.
> > 
> > In the past, I modified the write-protect probing in 2.4.x to be more compatible
> > with what usb-storage wanted.  But then someone changed it, and it broke.
> > So we changed it again... and it was fine for a while.  Then someone
> > changed it in 2.5.x, and it broke again.
> > 
> > I guess what's got me frustrated is that this is very fragile, tends to
> > cause serious problems when it fails, often gets changed, and isn't really
> > necessary -- after all, that's why the 'assume write-enabled' code path is
> > there for when the request fails.
> > 
> > I've just been around and around this merry-go-round, and I'm trying to get
> > off.  We can fix it now, but I am truly afraid that it's going to get
> > broken again in 6 months.
> 
> To some extent, I'm afraid you can't get off:  you're stuck on here with
> the rest of us.
> 
> I can't guarantee that changes to the SCSI subsystem won't break USB
> devices.  However, what I can guarantee is that we'll work to fix the
> problems as they arise.

Maybe it would help, just a little bit, to create a file in 
Documentation/scsi explaining some of the design choices and why they were 
made.  It could include a list of device types and the sorts of commands 
they choke on.

That way, when someone does change things in a way that breaks USB 
devices, you can at least say "You should have read 
Documentation/scsi/design_rules first!"

Alan Stern

