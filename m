From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Fri, 19 Dec 2003 09:51:12 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312190945170.805-100000@ida.rowland.org>
References: <20031219091450.GC828@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2052 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263400AbTLSOvO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2003 09:51:14 -0500
In-Reply-To: <20031219091450.GC828@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, David Brownell <david-b@pacbell.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 19 Dec 2003, Matthew Dharm wrote:

> On Fri, Dec 12, 2003 at 03:48:06PM -0700, Pat LaVarre wrote:
> > > Also, I'm open to requests for particular host/device option
> > > combinations.
> > 
> > My wish list is:
> > 
> > a) Device = x 08 (02|05|06) 50 = msft win generic usb-storage.
> 
> Did anyone ever get a chance to capture this data?
> 
> Matt

Andries Brouwer has just created a web page to hold USB Mass Storage 
traces, and I have submitted the ones I've had time to collect so far.  
They include Pat LaVarre's wish list, but only for Windows ME -- other 
versions of Windows will have to wait until the New Year or after.

The URL for my traces is:

http://www.win.tue.nl/~aeb/linux/usb/traces/winme/

Also present in that directory is a README.txt file, although it doesn't 
show up in the default directory listing.  You can retrieve it through

http://www.win.tue.nl/~aeb/linux/usb/traces/winme/README.txt

Alan Stern

