From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Fri, 5 Dec 2003 11:01:36 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312051049040.850-100000@ida.rowland.org>
References: <20031204210832.A1757@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:17156 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264155AbTLEQBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 11:01:37 -0500
In-Reply-To: <20031204210832.A1757@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Pat LaVarre <p.lavarre@ieee.org>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 4 Dec 2003, Patrick Mansfield wrote:

> On Thu, Dec 04, 2003 at 03:59:58PM -0500, Alan Stern wrote:
> 
> > It was generic (transparent) scsi.
> > 
> > Perhaps I'll try implementing some of the other protocol codes in FSG,
> > maybe also the "removeable media" flag.  This would also require
> > implementing the PREVENT-ALLOW-MEDIUM-REMOVAL, READ-FORMAT-CAPACITIES, and
> > START-STOP, possibly also REZERO-UNIT, SEEK, READ(12), and WRITE(12).
> 
> What is FSG?
> 
> -- Patrick Mansfield

Sorry about not explaining that.  FSG is my File-backed Storage Gadget.  
It's a driver for a Linux-based USB _device_ (as opposed to _host_) that 
emulates a USB Mass Storage device, using a file or block device as 
backing storage in somewhat the same manner as the loop driver.

Since FSG is totally under our control, it's perfect for logging the 
sequence of commands issued by an arbitrary host when connected to a 
generic USB storage device.  Unfortunately, although I am keenly 
interested in seeing the results of such tests against a variety of 
Windows hosts, I don't have any USB device hardware capable of running 
Linux.  So I have to rely on tests done by the relatively few people who 
do have such hardware.

Alan Stern

