From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Notify about errors during initialization
Date: Mon, 5 Jan 2004 17:04:59 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401051659180.604-100000@ida.rowland.org>
References: <20040105021047.GD30408@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2820 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265969AbUAEWFA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 17:05:00 -0500
In-Reply-To: <20040105021047.GD30408@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

James:

Can you or someone else on the SCSI development list answer this question?

When a new host is registered and scanned for devices, are we guaranteed
that the scanning procedure will be finished when scsi_scan_host()  
returns?

It sure looks that way to me, but I want to be certain -- Matt Dharm 
expressed some doubts.

The reason for asking is so that the usb-storage driver can test whether 
any devices were found.  Depressingly often some incompatibility causes 
the scan to fail, and when that happens it would be nice to put a 
notification in the system log, unregister the host, and generally avoid 
loading the driver as though everything was okay.

Thanks,

Alan Stern


> > On Sat, 6 Dec 2003, Matthew Dharm wrote:
> > 
> > > Question: Are we guaranteed that scsi_scan_host() doesn't return until the
> > > scanning process is complete?
> > 
> > > I recall a problem that we had with the setting of flags and the call to
> > > scan the host -- without pre-emption, it worked, but with pre-emption
> > > things happened in the wrong order.  Could that happen here?

