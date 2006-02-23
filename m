From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Blacklist flags for SCSI target vs. SCSI LUN
Date: Thu, 23 Feb 2006 11:17:00 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602231115360.5204-100000@iolanthe.rowland.org>
References: <06D63F45-3FD0-4871-BA3F-D5867A6D2FDA@ieee.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:24797 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751606AbWBWQRG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Feb 2006 11:17:06 -0500
In-Reply-To: <06D63F45-3FD0-4871-BA3F-D5867A6D2FDA@ieee.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 22 Feb 2006, Pat LaVarre wrote:

> >> NOTQ is for all requests
> >
> > All requests to the LUN or to the target?
> 
> All requests to the target was my guess, though clicking thru  
> BLIST_NOTQ might tell us more ...

It would probably be safest to assume that the target doesn't support 
tagged requests at all.  But there's a lot of existing code that treats 
this flag as per-LUN, so for now I'll keep it that way.

Thanks,

Alan Stern

