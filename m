From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Informational Exception mpage [was: usb storage traces]
Date: Fri, 5 Dec 2003 10:32:34 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312051025560.850-100000@ida.rowland.org>
References: <3FD001D4.9010404@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6660 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264405AbTLEPce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 10:32:34 -0500
In-Reply-To: <3FD001D4.9010404@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

On Fri, 5 Dec 2003, Douglas Gilbert wrote:

> The latest drafts of MMC-3 and MMC-4 call this mode page:
> "Fault/Failure Reporting Control Page". Looking at the
> definition in MMC-4 it is basically the same as the
> Informational Exceptions mode page defined in SPC-3 with
> a few fields reserved.

According to the USB Mass Storage Class - UFI Command Specification, which 
might be more applicable in this circumstance, page x1c is defined as the 
Timer and Protect page.

> Just to confuse things further there is an Informational
> Exceptions _log_ page that started life as the SMART log page.
> Seems as though someone in t10 is keen on the term
> "Informational Exceptions" but other groups are not so
> enthusiastic.
> 
> Various command sets (e.g. SSC (tapes) and MMC (cd/dvd)) "fine
> tune" the defintion of mode pages. Mode page 0x1c is the
> only one in which the name changes that I have noticed.
> SSC also overloads this mode page but keeps the SPC-3 name.

So it's hard to say whether Windows uses this page to control SMART 
logging, disk spin-down times, or something else.  I guess it's just as 
well that the devices I've looked at don't support it.

Alan Stern

