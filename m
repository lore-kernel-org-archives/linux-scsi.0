From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] add transport class symlink to device object
Date: Wed, 17 Aug 2005 22:21:56 -0700
Message-ID: <20050818052156.GC29301@kroah.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD35@xbl3.ma.emulex.com> <20050813213955.GB19235@kroah.com> <20050814150231.GA9466@parcelfarce.linux.theplanet.co.uk> <20050814232525.A27481@flint.arm.linux.org.uk> <20050815004303.GB9466@parcelfarce.linux.theplanet.co.uk> <20050815093244.A19811@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:7147 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S1750754AbVHRFlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 01:41:42 -0400
Content-Disposition: inline
In-Reply-To: <20050815093244.A19811@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, James.Smart@Emulex.Com, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Mon, Aug 15, 2005 at 09:32:44AM +0100, Russell King wrote:
> On Mon, Aug 15, 2005 at 01:43:03AM +0100, Matthew Wilcox wrote:
> > On Sun, Aug 14, 2005 at 11:25:25PM +0100, Russell King wrote:
> > > Eww.  Do you really want one struct device per tty with all the
> > > memory each one eats?
> > > 
> > > If that's really what you want you need to talk to Alan and not me.
> > > Alan looks after tty level stuff, I look after serial level stuff.
> > > The above is a tty level issue not a serial level issue.
> > 
> > mmm.  I don't know whether it's really a tty level issue or a serial
> > issue.  The only tty classes with corresponding devices are the serial
> > ones, at least on my system.  If this is the case, then the right fix
> > would seem to be something like creating a new struct device for each
> > serial port, then making that the uart_port->dev instead of the pci_dev
> > or whatever.
> 
> What's the reason for enforcing one struct device per struct class_dev ?
> I thought one of the points of class_dev was that you could have multiple
> of them per struct device.

No such enforcement is needed at all, and not encouraged.

thanks,

greg k-h
