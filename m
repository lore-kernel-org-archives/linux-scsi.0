From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [usb-storage] Re: [PATCH 0/3] SCSI & usb-storage: new flags for
 VPD pages and REPORT LUNS
Date: Wed, 25 Jan 2012 10:19:26 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1201251013560.1348-100000@iolanthe.rowland.org>
References: <5A9BC72FD5CEC94EA024CED8E31D701A2765C25A@wdscexmb03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47510 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752396Ab2AYPT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2012 10:19:27 -0500
In-Reply-To: <5A9BC72FD5CEC94EA024CED8E31D701A2765C25A@wdscexmb03.sc.wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: 'Greg KH' <greg@kroah.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Perry Wagle <wagle@mac.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 25 Jan 2012, Daniel Taylor wrote:

> I handled this a bit differently, for our old 2.6.32 kernel, based on
> discussions on this list with Matthew Dharm back in April 2011.
> 
> I changed the scsi_level entry in /sys to be read/write, rather than
> read-only.  This allows a ussr-space white-list handler to fixup
> drives that are known to work.
> 
> The gist of the discussion was whether the kernel should keep a white
> or black list for every drive on the planet to handle the scsi_level
> change/no-change or that user space could have the database and either
> apply it manually or automatically through udevd.  Matthew expressed
> a preference for user space to manage the information.
> 
> I can't find the patch set for these flag changes in my local email
> archive, but can we have controls for these available in user-space?

Is this really workable in practice?  The scsi_level value is used when 
scanning for LUNs and partitions, which doesn't give userspace much 
time to change the value.

Can you explain the reason why you need to change the scsi_level value?

Alan Stern

