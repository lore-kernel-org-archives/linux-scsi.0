From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: Mon, 28 Jul 2003 11:31:12 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307281129500.609-100000@ida.rowland.org>
References: <20030728150823.GC1399@gtf.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1540 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269981AbTG1PP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2003 11:15:57 -0400
In-Reply-To: <20030728150823.GC1399@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 28 Jul 2003, Jeff Garzik wrote:

> On Mon, Jul 28, 2003 at 10:10:33AM -0400, Alan Stern wrote:
> > Jens:
> > 
> > This patch changes the scsi_mode_sense() routine to retry up to a total of 
> > 3 times if a command fails with a UNIT ATTENTION sense key value.
> > 
> > Without this change, sr.c does not properly read the capabilities mode 
> > page for a just-powered-up cdrom drive -- it gives up upon receiving a 
> > Device Reset Occurred code.
> 
> I'm curious, are you testing against a real SCSI device, or a faked one
> as via ide-scsi.c?

Sort of in-between.  It's a USB CD-RW drive.  So it's not attached to a 
real SCSI bus, but it does use the genuine SCSI command set.

Alan Stern

