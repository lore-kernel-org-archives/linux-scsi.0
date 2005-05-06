From: Greg KH <greg@kroah.com>
Subject: Re: Empty partition nodes not created (was device node issues with recent mm's and udev)
Date: Fri, 6 May 2005 08:50:21 -0700
Message-ID: <20050506155020.GA6904@kroah.com>
References: <d4757e6005050219514ece0c0a@mail.gmail.com> <20050503031421.GA528@kroah.com> <20050502202620.04467bbd.rddunlap@osdl.org> <20050506080056.GD4604@pclin040.win.tue.nl> <20050506081009.GX23013@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:59361 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261200AbVEFPua (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2005 11:50:30 -0400
Content-Disposition: inline
In-Reply-To: <20050506081009.GX23013@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@osdl.org>
Cc: Andries Brouwer <aebr@win.tue.nl>, "Randy.Dunlap" <rddunlap@osdl.org>, joecool1029@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org

On Fri, May 06, 2005 at 01:10:09AM -0700, Chris Wright wrote:
> * Andries Brouwer (aebr@win.tue.nl) wrote:
> > No, there is no problem but an intentional change in behaviour in -mm
> > and now also in 2.6.11.8.
> 
> I think this should be backed out of -stable.

I agree, I'll go do it in the tree right now, sorry about this.

greg k-h
