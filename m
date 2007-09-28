From: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning
	down disk
Date: Thu, 27 Sep 2007 21:27:10 -0700
Message-ID: <20070928042710.GA24458@kroah.com>
References: <Pine.LNX.4.44L0.0709251012210.3909-100000@iolanthe.rowland.org> <200709251711.01216.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37238 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbXI1EXm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 00:23:42 -0400
Content-Disposition: inline
In-Reply-To: <200709251711.01216.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Tue, Sep 25, 2007 at 05:11:00PM +0200, Oliver Neukum wrote:
> 
> PS: Whoever designed klists is suffering from a case of overengineeringosis.

No objection from me there.  If you can think of a way to do list
traversal without taking locks, please, feel free to redo the whole
klist stuff.

As it was, Pat emerged out of nowhere, threw the code at us, it fixed
some locking issues I was trying to solve at the time, so I added it.
Then he ran away to a different continent :(

Oh well...

greg k-h
