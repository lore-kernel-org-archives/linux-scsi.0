From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] usb-storage: implement autosuspend
Date: Thu, 29 Jul 2010 07:19:07 -0700
Message-ID: <20100729141907.GA19172@kroah.com>
References: <20100728230912.GA32658@kroah.com> <Pine.LNX.4.44L0.1007291011500.1626-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab0G2OSV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 10:18:21 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1007291011500.1626-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Thu, Jul 29, 2010 at 10:14:45AM -0400, Alan Stern wrote:
> On Wed, 28 Jul 2010, Greg KH wrote:
> 
> > > > I think you forgot that I use quilt for my trees :)
> > > 
> > > There is a way of doing this in quilt.  I think you checkout my tree,
> > > add the patch and some type of annotation for the top so linux-next
> > > knows when to pull it in.
> > 
> > Yeah, there is a way, but it's a major pain and a divergant way of
> > handling my tree from what I do today :(
> > 
> > > You just want me to put it in my tree, don't you ... ?
> > 
> > I do :)
> > 
> > Please add an:
> > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > to it and have fun :)
> > 
> > If you really don't want to, just let me know and I'll handle it and the
> > merge issues myself, that's what the subsystem maintainer is for...
> 
> If James is willing to take the patch, that's fine.
> 
> If not, it can go into Greg's tree without any serious effect.  The 
> nice thing about this patch is that it will build okay without the 
> SCSI changes -- it just won't work properly if autosuspend is enabled 
> for a usb-storage device.  Since the default is to leave autosuspend 
> disabled, people won't get into trouble unless they deliberately try 
> to.

Ah, I thought it would break my build.  Ok, I'll take it then, James,
don't worry about it.

thanks,

greg k-h
