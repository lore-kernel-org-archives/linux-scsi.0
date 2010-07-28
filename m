From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] usb-storage: implement autosuspend
Date: Wed, 28 Jul 2010 16:29:42 -0500
Message-ID: <1280352582.30808.606.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1007281702030.1744-100000@iolanthe.rowland.org>
	 <1280351785.30808.603.camel@mulgrave.site>
	 <20100728212551.GA20508@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab0G1V3r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 17:29:47 -0400
In-Reply-To: <20100728212551.GA20508@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Wed, 2010-07-28 at 14:25 -0700, Greg KH wrote:
> On Wed, Jul 28, 2010 at 09:16:25PM +0000, James Bottomley wrote:
> > On Wed, 2010-07-28 at 17:12 -0400, Alan Stern wrote:
> > > Because this patch depends on those SCSI changes, either it should also 
> > > go via James's tree or else the SCSI patches should be imported into 
> > > Greg's tree first.  James and Greg, which route is easier for you?
> > 
> > They're USB patches, so they should be in a USB tree.  Just do a
> > standard postmerge tree based on SCSI.
> 
> Yeah, but then for now my tree will not build on its own, right?

Yes it will: a postmerge tree contains a buildable merge base and the
additional patches.  You can see how this is done at

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-post-merge-2.6.git

Which contains the ibft tree and scsi-misc as the merge base then has
be2iscsi patches that depend on both.  The tree is individually
buildable and linux-next only pulls in from merge-base to the top (have
to make sure it's included after all the other trees, though).

James


