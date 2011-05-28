From: Greg KH <greg@kroah.com>
Subject: Re: Kernel BUG after removing USB device
Date: Sun, 29 May 2011 05:47:28 +0800
Message-ID: <20110528214728.GC19246@kroah.com>
References: <Pine.LNX.4.44L0.1105271419170.2014-100000@iolanthe.rowland.org>
 <1306601646.5630.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44438 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614Ab1E1VrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2011 17:47:10 -0400
Content-Disposition: inline
In-Reply-To: <1306601646.5630.22.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Bruce Guenter <bruce@untroubled.org>, Jens Axboe <jaxboe@fusionio.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Sat, May 28, 2011 at 11:54:06AM -0500, James Bottomley wrote:
> On Fri, 2011-05-27 at 14:26 -0400, Alan Stern wrote:
> > Added a few entries to the CC: list.
> 
> Yes, it's a SCSI issue.  There's a fix already in play, although not
> actually applied upstream yet:
> 
> http://marc.info/?l=linux-scsi&m=130635674521428
> 
> It also relies on a couple of block patches (mentioned in the thread).

These are all marked properly so that -stable knows to pick them up,
right?
