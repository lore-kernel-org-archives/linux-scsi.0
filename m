From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [PATCH]indistinguishable devices with broken and
 unbroken firmware
Date: Wed, 7 Feb 2007 13:42:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702071340310.4502-100000@iolanthe.rowland.org>
References: <200702071616.55419.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57415 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161373AbXBGSmJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 13:42:09 -0500
In-Reply-To: <200702071616.55419.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org

On Wed, 7 Feb 2007, Oliver Neukum wrote:

> Am Mittwoch, 7. Februar 2007 16:05 schrieb Christoph Hellwig:
> > On Wed, Feb 07, 2007 at 03:22:39PM +0100, Oliver Neukum wrote:
> > > Hi,
> > > 
> > > there's a USB mass storage device which exists in two version. One
> > > reports the correct size and the other does not. Apart from that they
> > > are identical and cannot be told apart. Here's a heuristic based on the
> > > empirical finding that drives have even sizes. I know it's ugly, but it fixes
> > > an ugly bug.
> > 
> > Do we really need a second flag?  Alternatively fix_capacity could be
> > changed to mean fix size if odd.
> 
> Until we learn about devices which really do have an odd number of sectors.
> And then we'll have a problem. I'd like to avoid heuristics when we know
> for sure.

In fact there are devices which have an odd number of sectors.  I once 
thought that would be a good heuristic to apply to all devices, but it 
won't work.

Alan Stern

