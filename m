From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Tue, 20 Mar 2012 10:31:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203201028300.3013-100000@netrider.rowland.org>
References: <20120320142109.GA3693@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:53972 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752429Ab2CTObu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2012 10:31:50 -0400
In-Reply-To: <20120320142109.GA3693@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org

On Tue, 20 Mar 2012, Stanislaw Gruszka wrote:

> On Mon, Mar 19, 2012 at 05:03:44PM +0000, Bart Van Assche wrote:
...
> > I'm not an USB expert but I've had a quick look at
> > usb_stor_release_resources() in drivers/usb/storage/usb.c. As far as I
> > can see that function will only stop the usb_stor_control_thread() if
> > that thread has been scheduled after the last complete() call by the USB
> > queuecommand() function and before the complete() call in
> > usb_stor_release_resources() is executed. That looks like a race
> > condition to me.
> 
> CCing linux-usb, perhaps usb developers would like to take a look.

I don't understand what Bart wrote.  Why is there a race condition and 
why is it a problem?

Alan Stern

