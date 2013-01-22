From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: Fwd: 2TB USB hard drive for backing up
Date: Tue, 22 Jan 2013 10:43:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301221039350.1510-100000@iolanthe.rowland.org>
References: <2472909.UxI1EnLDV4@linux-5eaq.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34911 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753239Ab3AVPnI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2013 10:43:08 -0500
In-Reply-To: <2472909.UxI1EnLDV4@linux-5eaq.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Ellwood Blues <elwood.blue@gmail.com>, linux-efi@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Tue, 22 Jan 2013, Oliver Neukum wrote:

> On Tuesday 22 January 2013 11:05:35 James Bottomley wrote:
> > > May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
> > > 1565565872 512-byte logical blocks: (801 GB/746 GiB)
> > 
> > This looks like a wrap around of your actual size.  This appears to
> > indicate the device isn't replying correctly to READ CAPACITY.  The
> > conventional return from READ CAPACITY should be -1 which would trigger
> > us to retry with READ CAPACITY(16).
> 
> What can we do? The answer the device is giving is quite ordinary.
> Do we need another quirk and an associated flag?

The JMicron bridges are well known to be fairly buggy.  Another quirk 
may indeed be the only solution.  Oliver, would you like to write a 
patch for it?

Alan Stern

