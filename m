From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC7xxx on 2.6.18
Date: Tue, 30 Jan 2007 07:18:20 -0500
Message-ID: <20070130121820.GA11843@animx.eu.org>
References: <20070128194620.GA6358@animx.eu.org> <20070128162408.9fffb6de.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:48237 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965333AbXA3NGa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 08:06:30 -0500
Content-Disposition: inline
In-Reply-To: <20070128162408.9fffb6de.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

NOTE: I am not on the linux-scsi list, keep me in CC.

Andrew Morton wrote:
> On Sun, 28 Jan 2007 14:46:20 -0500
> Wakko Warner <wakko@animx.eu.org> wrote:
> 
> > I have 2 machine that oops with these cards.
> > 
> > 1) The bios has the option to enable/disable option roms on individual PCI
> > slots.  I have an AHA-39160 and an AHA-2940U/UW (dual channel).  If I
> > disable option roms, the driver oopses when accessing the 2nd card.
> > 
> > I can get the oops if really needed as I don't like rebooting this machine.
> > 
> > 2) I have an AHA-39160 with Apple/Mac firmware.  When attempting to use it
> > on a PC, the driver oopses presumably because the card wasn't initialized or
> > something.  I realize this is probably not a supported configuration, but I
> > don't believe that it should be oopsing.
> > 
> > I can get the oops for this one if it'll help.
> 
> Yes, getting the oops traces will help, thanks.  And confirmation on a more
> recent kernel would be good.

I tested with a 2.6.20-rc6 kernel and the MAC 39160 card.  There was no oops
and I was able to access the 2 disks.  This was on a different PC though. 
I'll try it again on the original PC.

Should I try 2.6.19 as well?

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
