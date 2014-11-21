From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: 3.16 commit 89fb4cd errors on drives without
 SYNC CACHE
Date: Fri, 21 Nov 2014 10:08:02 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411211003130.1124-100000@iolanthe.rowland.org>
References: <20141121101733.GA23135@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59906 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757880AbaKUPID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 10:08:03 -0500
In-Reply-To: <20141121101733.GA23135@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff DeFouw <mrj@plorb.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Fri, 21 Nov 2014, Christoph Hellwig wrote:

> > usb-storage sets wce_default_on only for devices that are marked with 
> > the US_FL_WRITE_CACHE quirk flag.  Currently only two devices have that 
> > flag: the Seagate Portable HDD (vendor ID 0x0bc2, product ID 0x2300) 
> > and the Western Digital My Password HDD (vendor ID 0x1058, product ID 
> > 0x070a).
> 
> So Jeff has a drive that on its own claims WCE=1 but doesn't support
> SYNCHRONIZE_CACHE(10).  I'm not sure what to do about it as it sounds
> inherently dangerous.

Maybe we should log a one-time warning when this happens and turn off 
sdkp->WCE.  There's not much else we _can_ do about it.

Alan Stern

