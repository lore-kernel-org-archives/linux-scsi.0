From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Implementation of SCSI dynamic power management
Date: Mon, 7 Jan 2008 16:34:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801071632180.6739-100000@iolanthe.rowland.org>
References: <200801072131.05755.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53322 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760079AbYAGVew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 16:34:52 -0500
In-Reply-To: <200801072131.05755.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>

On Mon, 7 Jan 2008, Oliver Neukum wrote:

> Am Montag, 7. Januar 2008 20:42:23 schrieb Alan Stern:
> > When all the devices under a host are suspended, the LLD is informed 
> > (via a new "autosuspend" method in the host template) so that it can
> 
> That is most certainly a mistake.

Why?

> Is there a good reason to not modify
> to extend suspend() to take an extra argument for the reason it is called?

In fact suspend methods already do take an argument specifying the
reason they were called.  It wouldn't be hard to add a couple of extra 
PM_EVENT_* values for manual suspend and autosuspend.  The problem is 
that resume methods don't take a corresponding argument.

Alan Stern

