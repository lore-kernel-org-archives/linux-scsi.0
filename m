From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Sun, 18 May 2003 14:31:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305181429170.29233-100000@netrider.rowland.org>
References: <3EC66465.6020700@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:54795 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262157AbTERSS1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 May 2003 14:18:27 -0400
In-Reply-To: <3EC66465.6020700@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Mike Anderson <andmike@us.ibm.com>, Florin Iucha <florin@iucha.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Sat, 17 May 2003, David Brownell wrote:

> That reset couldn't re-assign the address, so of course it failed.
> 
> In hub.c, usb_physical_reset_device() is leaving dev->state as
> USB_STATE_CONFIGURED after resetting the port, and of course it's
> not legal to set the address of a device in that state.

Do you mean to say that this is a bug in usb_reset_device()?  Isn't it 
always going to be true that after a port reset a device will need to be 
assigned an address?

Alan Stern

