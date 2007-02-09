From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH]indistinguishable devices with broken and unbroken firmware #2
Date: Thu, 8 Feb 2007 17:20:53 -0800
Message-ID: <20070209012053.GE2685@suse.de>
References: <200702080904.48806.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945988AbXBIBWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Feb 2007 20:22:05 -0500
Content-Disposition: inline
In-Reply-To: <200702080904.48806.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Thu, Feb 08, 2007 at 09:04:48AM +0100, Oliver Neukum wrote:
> Hi,
> 
> there's a USB mass storage device which exists in two version. One
> reports the correct size and the other does not. Apart from that they
> are identical and cannot be told apart. Here's a heuristic based on the
> empirical finding that drives have even sizes.
> 
> The requested changes have been made.
> Greg, can this go through your tree?

If the usb-storage people ACK it, I'll be glad to add it to my trees.

thanks,

greg k-h
