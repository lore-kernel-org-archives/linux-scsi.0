From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 09:15:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067357742.1105.37.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310281036480.793-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:8708 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S264010AbTJ1QRF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 11:17:05 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310281036480.793-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

Alan,
sorry. Still working on my coffee.
I just looked at my .config and debug is turned on:

CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y

Any special sysctl you want me to set, didn't see anything in the
Documentation/usb dir to this regard.
And while I'm on it, do you need scsi debugging info with the usb debug
info, to see the interaction. Or should I just use usb debug?
Thanks,
Ronald



On Tue, 2003-10-28 at 08:40, Alan Stern wrote:
> On Tue, 28 Oct 2003, Patrick Mansfield wrote:
> 
> > On Tue, Oct 28, 2003 at 10:03:06AM -0500, Alan Stern wrote:
> > 
> > > It's not clear to me what is the best way to take care of the devices that 
> > > choke on page 3F.  Should we use a special flag for those devices or 
> > > should we disable it entirely?
> > 
> > I don't know, good question.
> > 
> > And more generally, should we add devices to the scsi_devinfo.c blacklist,
> > and only use the dynamic addition to the black list until the new code is
> > available?
> 
> That might be the best thing to do.
> 
> > I am still looking at the logs - I don't see any logging of the actual
> > failure, and I did not see a failure immediately after the 3f was sent.
> 
> This sort of thing doesn't show up very well in the scsi debugging logs.  
> You can see it much more clearly in the verbose usb-storage debugging log.  
> 
> Ronald, you might try taking the BLIST_MS_SKIP_PAGE_3F flag back out and 
> configuring usb-storage debugging on.  Then post the debugging log so we 
> can see exactly what's happening.
> 
> Alan Stern
> 
> 
> 

