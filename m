From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: Wed, 30 Jul 2003 10:09:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307301008460.2868-100000@ida.rowland.org>
References: <1059520994.2298.263.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2820 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S272905AbTG3OJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 10:09:24 -0400
In-Reply-To: <1059520994.2298.263.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On 29 Jul 2003, James Bottomley wrote:

> On Mon, 2003-07-28 at 10:10, Alan Stern wrote:
> > Jens:
> > 
> > This patch changes the scsi_mode_sense() routine to retry up to a total of 
> > 3 times if a command fails with a UNIT ATTENTION sense key value.
> > 
> > Without this change, sr.c does not properly read the capabilities mode 
> > page for a just-powered-up cdrom drive -- it gives up upon receiving a 
> > Device Reset Occurred code.
> > 
> > The patch looks lengthy, but most of it just changes the indentation 
> > level.
> 
> Actually, this isn't really the correct place for it.  The problem
> occurs in sr not sd because sd already does an initial TUR to clear the
> unit attention.
> 
> Before OLS got in the way and I got submerged in writing presentations,
> I had some patches that Matt Dharm was testing out to add the TUR to the
> initial sr code.
> 
> I'll pick that up (...er, when I get caught back up at work).

Okay, that ought to take care of it just as well.

Thanks.

Alan Stern

