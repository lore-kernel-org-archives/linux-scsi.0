From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Wed, 6 Feb 2008 17:18:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802061708460.7110-100000@iolanthe.rowland.org>
References: <20080206210511.GA30466@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50421 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757211AbYBFWSW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 17:18:22 -0500
In-Reply-To: <20080206210511.GA30466@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mark Glines <mark@glines.org>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 6 Feb 2008, Matthew Dharm wrote:

> Maybe this is a crazy question, but...
> 
> Why is this not in the SCSI core?

Or even in the block core?

>  It's hardly USB-specific, and I'm
> willing to bet that there are other HCDs (at least spb2) which need to do
> this sort of thing...

James, do you have any idea?

What we're talking about is a routine that provides drivers a simple
way to access the data in a scatter-gather buffer (which may lie in
highmem or otherwise not be easily reachable).  The idea is that some 
commands are emulated by the driver rather than carried out by the 
device, and the driver needs some way to stick the results in the 
transfer buffer.

Alan Stern

