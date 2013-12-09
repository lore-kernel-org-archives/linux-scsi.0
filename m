From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: CONFIG_SCSI_MULTI_LUN default
Date: Mon, 09 Dec 2013 11:35:56 -0800
Message-ID: <1386617756.2028.104.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1312091423120.1439-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36314 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755833Ab3LITf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2013 14:35:59 -0500
In-Reply-To: <Pine.LNX.4.44L0.1312091423120.1439-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2013-12-09 at 14:28 -0500, Alan Stern wrote:
> On Mon, 9 Dec 2013, James Bottomley wrote:
> 
> > On Mon, 2013-12-09 at 13:24 -0500, Alan Stern wrote:
> > > James:
> > > 
> > > Is there any good reason why CONFIG_SCSI_MULTI_LUN still doesn't 
> > > default to Y?
> > 
> > Assuming we've got all the screw ups (mostly CD ROMS) blacklisted, I
> > think the only real reason is that some SCSI-2 devices don't respond to
> > stuff not on LUN 0, so it keeps the boot process quick.
> > 
> > There isn't really any reason to change it, though, is there?  The
> > option only applies to SCSI-2 and below devices which should be a self
> > obsoleting class as their motors start to burn out.
> 
> I'm asking because every now and then we hear from somebody who built a
> kernel without SCSI_MULTI_LUN and then doesn't understand why his USB
> card reader seems to support only one type of card.  (The interfaces
> for different digital card types typically are presented as different
> logical units on USB card readers.)
> 
> This isn't a big deal; if boot-up time is a real reason for not
> defaulting to Y, that's fine.

How about we fix this in another way?  If you can identify the class of
devices which constitute card readers can't we just set BLIST_FORCELUN
for them.  That way the config option can continue to die.

James



