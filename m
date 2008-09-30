From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 15:34:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809301530170.3494-100000@iolanthe.rowland.org>
References: <1222798046.3232.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43293 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753364AbYI3Tew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 15:34:52 -0400
In-Reply-To: <1222798046.3232.59.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 30 Sep 2008, James Bottomley wrote:

> However, there's a slight problem in that some senses need to be
> interpreted differently depending on what the ULD is which leads to the
> current 3 tier system (before in decide disposition, during in ULD done
> and after in scsi_io_completion).
> 
> The discriminators in the done functions do look to be duplicates, so I
> suppose they could be collapsed.

Related to this in a minor way is my patch from September 25, which
removes from sd_done() the code to update the use_10_for_rw and
use_10_for_ms flags:

	http://marc.info/?l=linux-scsi&m=122236940613587&w=2

This change has now been confirmed to fix a problem that previously 
caused a disk drive to be unusable:

https://lists.one-eyed-alien.net/pipermail/usb-storage/2008-September/004022.html

Alan Stern

