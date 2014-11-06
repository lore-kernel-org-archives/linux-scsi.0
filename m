From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Large disk drives
Date: Thu, 6 Nov 2014 12:47:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411061240290.1206-100000@iolanthe.rowland.org>
References: <201411052330.sA5NUSCG019414@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40950 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751367AbaKFRrh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 12:47:37 -0500
In-Reply-To: <201411052330.sA5NUSCG019414@hobgoblin.ariadne.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, 5 Nov 2014, Dale R. Worley wrote:

> > From: Alan Stern <stern@rowland.harvard.edu>
> 
> > I posted a patch to allow the user to override the reported capacity:
> > 
> > 	http://marc.info/?l=linux-scsi&m=140993840113445&w=2
> 
> I see the patch, and I feel confident I could install it if I needed
> to.  What command do I execute to "write to the capacity_override
> attribute", before I do "blockdev --rereadpt /dev/sdX"?

As root:

	echo N >/sys/class/scsi_disk/D:D:D:D/capacity_override

where N is the number of blocks and D:D:D:D is the device name
corresponding to the sdX disk.  Or if you prefer, an equivalent path
would be

	/sys/block/sdX/device/scsi_disk/D:D:D:D/capacity_override

and here you wouldn't have to guess at the value of D:D:D:D because it 
would be the only entry in the /sys/block/sdX/device/scsi_disk 
directory.

Alan Stern

