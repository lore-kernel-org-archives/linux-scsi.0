From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] usb-storage: implement autosuspend
Date: Wed, 28 Jul 2010 14:35:21 -0700
Message-ID: <20100728213521.GA22064@kroah.com>
References: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
 <1280351785.30808.603.camel@mulgrave.site>
 <20100728212551.GA20508@kroah.com>
 <1280352582.30808.606.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391Ab0G1VfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 17:35:24 -0400
Content-Disposition: inline
In-Reply-To: <1280352582.30808.606.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Wed, Jul 28, 2010 at 04:29:42PM -0500, James Bottomley wrote:
> On Wed, 2010-07-28 at 14:25 -0700, Greg KH wrote:
> > On Wed, Jul 28, 2010 at 09:16:25PM +0000, James Bottomley wrote:
> > > On Wed, 2010-07-28 at 17:12 -0400, Alan Stern wrote:
> > > > Because this patch depends on those SCSI changes, either it should also 
> > > > go via James's tree or else the SCSI patches should be imported into 
> > > > Greg's tree first.  James and Greg, which route is easier for you?
> > > 
> > > They're USB patches, so they should be in a USB tree.  Just do a
> > > standard postmerge tree based on SCSI.
> > 
> > Yeah, but then for now my tree will not build on its own, right?
> 
> Yes it will: a postmerge tree contains a buildable merge base and the
> additional patches.  You can see how this is done at
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-post-merge-2.6.git
> 
> Which contains the ibft tree and scsi-misc as the merge base then has
> be2iscsi patches that depend on both.  The tree is individually
> buildable and linux-next only pulls in from merge-base to the top (have
> to make sure it's included after all the other trees, though).

I think you forgot that I use quilt for my trees :)

thanks,

greg "old-skool" k-h
