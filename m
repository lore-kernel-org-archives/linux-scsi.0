From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 30/33] USB storage: sg chaining support
Date: Tue, 17 Jul 2007 09:07:58 +0200
Message-ID: <20070717070757.GC5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792692184-git-send-email-jens.axboe@oracle.com> <20070717061218.GA16976@kroah.com> <20070717070102.GA5195@kernel.dk> <20070717070536.GA18359@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:8397 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbXGQHIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 03:08:34 -0400
Content-Disposition: inline
In-Reply-To: <20070717070536.GA18359@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 17 2007, Greg KH wrote:
> On Tue, Jul 17, 2007 at 09:01:02AM +0200, Jens Axboe wrote:
> > On Mon, Jul 16 2007, Greg KH wrote:
> > > On Mon, Jul 16, 2007 at 11:47:44AM +0200, Jens Axboe wrote:
> > > > [PATCH] USB storage: sg chaining support
> > > > 
> > > > Modify usb_stor_access_xfer_buf() to take a pointer to an sg
> > > > entry pointer, so we can keep track of that instead of passing
> > > > around an integer index (which we can't use when dealing with
> > > > multiple scatterlist arrays).
> > > > 
> > > > Cc: greg@kroah.com
> > > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > 
> > > No objection from me, I'm guessing this needs to go through the scsi
> > > tree?
> > 
> > Yes it will, I just want to make sure that the relevant people have seen
> > (and preferably acked them :) the changes before they go in eventually.
> 
> You might want to pass this one by the usb-storage developer to make
> sure.

OK, will do.

-- 
Jens Axboe

