From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 10:35:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908111034360.2562-100000@iolanthe.rowland.org>
References: <yq1y6pre160.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49120 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754001AbZHKOfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 10:35:53 -0400
In-Reply-To: <yq1y6pre160.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Aug 2009, Martin K. Petersen wrote:

> >>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> Alan,
> 
> >> If the bridge doesn't provide the SCSI rev. where does it come from?
> >> Or are you saying there's a USB "target" chip and then a USB-SATA
> >> bridge chip behind it?
> 
> Alan> There's the bridge chip and the drive itself.  The drive provides
> Alan> the INQUIRY data and the chip provides the USB identifiers.
> 
> But the drive is ATA.  It must be the bridge that translates whatever
> the drive reports in IDENTIFY DEVICE into something that makes sense in
> the SPC/SBC universe.

Right.  The drive provides the data, and the bridge massages it into
the form of an INQUIRY response and sends it back to the host.

Alan Stern

