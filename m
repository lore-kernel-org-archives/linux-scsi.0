From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Fri, 5 Dec 2003 10:01:10 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312050954360.850-100000@ida.rowland.org>
References: <1070576669.2269.108.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4100 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264266AbTLEPBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 10:01:11 -0500
In-Reply-To: <1070576669.2269.108.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

On 4 Dec 2003, Pat LaVarre wrote:

> > Does anybody know what ... mode page x1c do?  Although 
> > nominally vendor-specific, they must be reasonably standardized if Windows 
> > can get away with using them on a generic device.

According to my newly-located source, page x1c is the Timer and Protect
page.  It includes values for the Inactivity Time Multiplier, Disable
Media Access, and Software Write Protect.

Windows may use it to try and set the drive's spin-down time.

Incidentally, Pat, can you confirm whether bInterfaceSubClass x01 = RBC 
(Reduced Block Commands, T10 project 1240-D) uses 0-padding of commands to 
12 bytes or not?  The Linux usb-storage driver seems to think that it 
doesn't.

Alan Stern

