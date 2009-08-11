From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/7] Fix various bugs in the target code
Date: Tue, 11 Aug 2009 11:12:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111109470.2562-100000@iolanthe.rowland.org>
References: <1249919600.4089.111.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41278 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752740AbZHKPMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 11:12:01 -0400
In-Reply-To: <1249919600.4089.111.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Aug 2009, James Bottomley wrote:

> > 	scsi_sysfs_add_sdev() would call transport_configure_device()
> > 	for a target each time a new device was added under that
> > 	target.  The call has been moved to scsi_target_add(), where
> > 	it will be made only once.
> 
> That, unfortunately is an SPI required feature ... we can't actually
> configure the target until we have a device because of the way SPI
> parameters work.

Would it be sufficient to call transport_configure_device() only the
first time a device is added?

Alan Stern

