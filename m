From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Mon, 14 Feb 2005 12:07:33 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502141204460.1175-100000@ida.rowland.org>
References: <20050214072005.GA8586@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:11012 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261488AbVBNRHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 12:07:39 -0500
In-Reply-To: <20050214072005.GA8586@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Mon, 14 Feb 2005, Olaf Hering wrote:

>  On Thu, Feb 10, Alan Stern wrote:
> 
> > And Mike Anderson's response was
> > 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=110538854224319&w=2
> > 
> > His explanation was "Currently scsi_host_cancel being called from
> > scsi_remove_host appears to not do anything as scsi_forget_host removes
> > the devices from the list it iterates over."  I don't know whether this 
> > problem has been fixed yet.
> 
> So, does anyone else know if that has been fixed, are there any patches
> I can try?
> Just plugging it in and out with init=/bin/bash doesnt trigger the oops.

In fact I wrote a patch back in November that ought to work around the 
problem, assuming this really is the problem you are seeing.  The patch 
still applies with a few offsets.  It's available at

https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-November/001201.html

Alan Stern

