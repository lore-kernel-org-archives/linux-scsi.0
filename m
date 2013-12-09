From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: CONFIG_SCSI_MULTI_LUN default
Date: Mon, 9 Dec 2013 14:28:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312091423120.1439-100000@iolanthe.rowland.org>
References: <1386614243.2028.101.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39853 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761204Ab3LIT2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2013 14:28:18 -0500
In-Reply-To: <1386614243.2028.101.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 9 Dec 2013, James Bottomley wrote:

> On Mon, 2013-12-09 at 13:24 -0500, Alan Stern wrote:
> > James:
> > 
> > Is there any good reason why CONFIG_SCSI_MULTI_LUN still doesn't 
> > default to Y?
> 
> Assuming we've got all the screw ups (mostly CD ROMS) blacklisted, I
> think the only real reason is that some SCSI-2 devices don't respond to
> stuff not on LUN 0, so it keeps the boot process quick.
> 
> There isn't really any reason to change it, though, is there?  The
> option only applies to SCSI-2 and below devices which should be a self
> obsoleting class as their motors start to burn out.

I'm asking because every now and then we hear from somebody who built a
kernel without SCSI_MULTI_LUN and then doesn't understand why his USB
card reader seems to support only one type of card.  (The interfaces
for different digital card types typically are presented as different
logical units on USB card readers.)

This isn't a big deal; if boot-up time is a real reason for not
defaulting to Y, that's fine.

Alan Stern

