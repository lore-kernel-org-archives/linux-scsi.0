From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Tue, 8 Jan 2008 13:51:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801081349510.4804-100000@iolanthe.rowland.org>
References: <4783BBC0.2070802@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59562 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753056AbYAHSvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 13:51:05 -0500
In-Reply-To: <4783BBC0.2070802@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Tue, 8 Jan 2008, Stefan Richter wrote:

> > How about something more like this:
> > 
> > *	Resume (return to an operational power level) the specified host,
> > *	and prevent autosuspends from other software layers until the
> > *	template autosuspend method has been called again.
> > *	Return 0 if the resume was successful, otherwise a negative
> > *	error code.
> 
> Who prevents them?  The autoresume() implementation, or its caller?

The autoresume implementation.  This comment explains what the function 
is supposed to do, not what its caller does.

Alan Stern

