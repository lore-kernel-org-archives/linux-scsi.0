From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type storage
 devices?
Date: Wed, 10 Mar 2004 11:56:20 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0403101152150.845-100000@ida.rowland.org>
References: <20040310091312.GA25632@apps.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3844 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262706AbUCJQ4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 11:56:21 -0500
In-Reply-To: <20040310091312.GA25632@apps.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 10 Mar 2004, Andries Brouwer wrote:

> An oft repeated maxim is: do as Windows does - and that may be
> a good idea. On the other hand, half of my devices come with their
> own drivers, and also fail under Windows without their own driver.
> 
> The conclusion is that yes, if you change something here then
> almost certainly there will be devices that are broken by the
> change, but the change may still be an improvement if there
> are more devices that were broken and now function.

It would be hard to determine the actual numbers for comparison.  On the
other hand, if a device requires a special driver for Windows then perhaps
it's not so bad if it also requires a special SCSI device-flags entry for
Linux.

Another obvious but important point to keep in mind is that whatever
changes are made, they must work correctly with actual (not emulated or
USB) SCSI devices.

Alan Stern

