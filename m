From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 30/33] USB storage: sg chaining support
Date: Tue, 17 Jul 2007 00:05:36 -0700
Message-ID: <20070717070536.GA18359@kroah.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792692184-git-send-email-jens.axboe@oracle.com> <20070717061218.GA16976@kroah.com> <20070717070102.GA5195@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:51865 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbXGQHGG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 03:06:06 -0400
Content-Disposition: inline
In-Reply-To: <20070717070102.GA5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 17, 2007 at 09:01:02AM +0200, Jens Axboe wrote:
> On Mon, Jul 16 2007, Greg KH wrote:
> > On Mon, Jul 16, 2007 at 11:47:44AM +0200, Jens Axboe wrote:
> > > [PATCH] USB storage: sg chaining support
> > > 
> > > Modify usb_stor_access_xfer_buf() to take a pointer to an sg
> > > entry pointer, so we can keep track of that instead of passing
> > > around an integer index (which we can't use when dealing with
> > > multiple scatterlist arrays).
> > > 
> > > Cc: greg@kroah.com
> > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > 
> > No objection from me, I'm guessing this needs to go through the scsi
> > tree?
> 
> Yes it will, I just want to make sure that the relevant people have seen
> (and preferably acked them :) the changes before they go in eventually.

You might want to pass this one by the usb-storage developer to make
sure.

thanks,

greg k-h
