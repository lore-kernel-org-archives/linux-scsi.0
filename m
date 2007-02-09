From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH]indistinguishable devices with broken and unbroken firmware
 #2
Date: Fri, 9 Feb 2007 10:30:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702091029560.4548-100000@iolanthe.rowland.org>
References: <20070209012053.GE2685@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47933 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946534AbXBIPak (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 10:30:40 -0500
In-Reply-To: <20070209012053.GE2685@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Oliver Neukum <oneukum@suse.de>, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On Thu, 8 Feb 2007, Greg KH wrote:

> On Thu, Feb 08, 2007 at 09:04:48AM +0100, Oliver Neukum wrote:
> > Hi,
> > 
> > there's a USB mass storage device which exists in two version. One
> > reports the correct size and the other does not. Apart from that they
> > are identical and cannot be told apart. Here's a heuristic based on the
> > empirical finding that drives have even sizes.
> > 
> > The requested changes have been made.
> > Greg, can this go through your tree?
> 
> If the usb-storage people ACK it, I'll be glad to add it to my trees.

It's okay with me.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

