From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 10:40:35 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310281036480.793-100000@ida.rowland.org>
References: <20031028071637.B8503@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:6916 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264001AbTJ1Pkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 10:40:36 -0500
In-Reply-To: <20031028071637.B8503@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Ronald Kuetemeier <ronald@kuetemeier.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 28 Oct 2003, Patrick Mansfield wrote:

> On Tue, Oct 28, 2003 at 10:03:06AM -0500, Alan Stern wrote:
> 
> > It's not clear to me what is the best way to take care of the devices that 
> > choke on page 3F.  Should we use a special flag for those devices or 
> > should we disable it entirely?
> 
> I don't know, good question.
> 
> And more generally, should we add devices to the scsi_devinfo.c blacklist,
> and only use the dynamic addition to the black list until the new code is
> available?

That might be the best thing to do.

> I am still looking at the logs - I don't see any logging of the actual
> failure, and I did not see a failure immediately after the 3f was sent.

This sort of thing doesn't show up very well in the scsi debugging logs.  
You can see it much more clearly in the verbose usb-storage debugging log.  

Ronald, you might try taking the BLIST_MS_SKIP_PAGE_3F flag back out and 
configuring usb-storage debugging on.  Then post the debugging log so we 
can see exactly what's happening.

Alan Stern



