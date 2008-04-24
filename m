From: Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before
	mounting root
Date: Thu, 24 Apr 2008 15:56:04 -0700
Message-ID: <20080424225604.GA18737@kroah.com>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40136 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYDXW7F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:59:05 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2008 at 12:25:04AM +0300, Pekka J Enberg wrote:
> On Thu, 24 Apr 2008, Pekka J Enberg wrote:
> > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > > 
> > > Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the kernel
> > > wait until background scanning of USB mass storage devices is complete before
> > > attempting to mount the root filesystem.
> > > 
> > > The config option is an alternative to the root_delay= kernel parameter
> > > solution people currently use to boot from USB mass storage devices.
> 
> On Thu, 24 Apr 2008, Alan Stern wrote:
> > This doesn't take into account what happens when CONFIG_SCSI_SCAN_ASYNC
> > is set.
> 
> Oh, right. Thanks! So something like the following should take care of it.
> 
> 		Pekka
> 
> Subject: [RFC/PATCH] usb-storage: wait for device scanning before mounting root V2
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the kernel
> wait until background scanning of USB mass storage devices is complete before
> attempting to mount the root filesystem.

What happens if there is no USB device present in the system?  Because
of that, there is no way that this option could ever be enabled by any
distro or anyone wanting their kernel to run on more than one machine :(

I don't like it.

thanks,

greg k-h
