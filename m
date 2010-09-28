From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] UAS driver
Date: Tue, 28 Sep 2010 00:25:56 -0700
Message-ID: <20100928072556.GA11571@kroah.com>
References: <20100928050733.GB3799@linux.intel.com> <20100928055649.GB8922@kroah.com> <20100928064549.GD3799@linux.intel.com> <20100928070613.GA11056@kroah.com> <20100928071711.GE3799@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:50622 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab0I1HZZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 03:25:25 -0400
Content-Disposition: inline
In-Reply-To: <20100928071711.GE3799@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>

On Tue, Sep 28, 2010 at 03:17:11AM -0400, Matthew Wilcox wrote:
> On Tue, Sep 28, 2010 at 12:06:13AM -0700, Greg KH wrote:
> > > I don't intend to add 0xaa to a header file ... I see its inclusion in
> > > this driver as a temporary thing, and I'd rather remove support for it
> > > than add it to a header.
> > 
> > I'm afraid to ask what the 0xaa is, but here goes, what is it?
> 
> It's a prototype device that has the wrong protocol ID.  Eventually I'll
> just drop support for it from the driver, but it's a useful device
> to keep testing with for the moment (it supports some aspects of the
> protocol that other devices I have access to don't).
> 
> Since nobody else is likely to have one, I'd rather take the line out
> of the in-tree driver and patch it back in locally, than I would add it
> to the header file.

Ok, that sounds good to me.

thanks,

greg k-h
