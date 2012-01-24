From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/3] SCSI & usb-storage: new flags for VPD pages and
 REPORT LUNS
Date: Tue, 24 Jan 2012 12:01:22 -0800
Message-ID: <20120124200122.GA7739@kroah.com>
References: <E9801365-C2D1-4E5C-8BE4-BD712DA0D2FD@mac.com>
 <Pine.LNX.4.44L0.1201101327030.1594-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34359 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756318Ab2AXURj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 15:17:39 -0500
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 1A46A20BC4
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2012 15:17:39 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201101327030.1594-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Perry Wagle <wagle@mac.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Jan 10, 2012 at 01:42:40PM -0500, Alan Stern wrote:
> James and Greg:
> 
> Perry Wagle reports that his new USB-ESATA drives don't work properly 
> because they don't like getting the LUN bits in the second byte of the 
> command string.  We set those bits only because usb-storage adjusts the 
> SCSI revision level for all devices to SCSI-2; the drives themselves 
> report a value of 0x06 (which would be SCSI-7).
> 
> The reason for mangling the scsi_level value was that some USB devices 
> reported SCSI-3 but couldn't handle some of the mandatory features: VPD 
> pages and the REPORT LUNS command.  It's now clear that instead of 
> abusing scsi_level, we should have separate flags for the individual 
> features we need to control.
> 
> That's what this patch series does.  The first merely corrects an 
> existing typo in the definition of struct scsi_target.  The second adds 
> the new flags and makes usb-storage use them.  The third takes this 
> opportunity to do a little code clean-up in usb-storage.
> 
> The changes are more or less equally divided between SCSI and
> usb-storage.  James, if they look okay to you and you don't mind taking
> them through your tree, that would be fine.  Or if you prefer, I'm sure
> Greg won't mind taking them.

I'll be glad to take these, James, any objection?

thanks,

greg k-h
