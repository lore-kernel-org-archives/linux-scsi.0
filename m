From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Wed, 24 Feb 2010 20:07:53 +0100
Message-ID: <20100224190753.GF1025@kernel.dk>
References: <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com> <Pine.LNX.4.44L0.1002241123220.2436-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43796 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607Ab0BXTHy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2010 14:07:54 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002241123220.2436-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ramya Desai <ramya.desai@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Wed, Feb 24 2010, Alan Stern wrote:
> >  However, this time, still my device
> > received 512 KB (1024) data transfer buffers in scsi_command.
> 
> At this point everything was set up correctly.  I don't know why the 
> transfer lengths are still 512 KB.  Maybe someone else has an idea.

What is the test case issuing the IO? Depending on the device, it may
hit other restrictions aside from just maximum transfer length.

-- 
Jens Axboe

