From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: can all 53c7xx-related stuff be removed?
Date: Sat, 9 Feb 2008 14:12:07 -0500 (EST)
Message-ID: <alpine.LFD.1.00.0802091410470.15018@localhost.localdomain>
References: <alpine.LFD.1.00.0802091151440.5998@localhost.localdomain> <20080209184947.GC28967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:38083 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbYBITMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 14:12:15 -0500
In-Reply-To: <20080209184947.GC28967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org


On Sat, 9 Feb 2008, Matthew Wilcox wrote:

> On Sat, Feb 09, 2008 at 11:54:43AM -0500, Robert P. J. Day wrote:
> >   just an observation that, even though 53c7xx content has been
> > officially removed, there are still a few droppings hanging around the
> > tree:
>
> Erm.  It's not just a driver, it's also the name of some chips.
>
> > $ grep -r 53c7xx *
> > arch/m68k/Makefile:# without -fno-strength-reduce the 53c7xx.c driver fails ;-(
>
> Ask the m68k guys.  Obviously, the comment can go away, but maybe they
> want to remove -fno-strength-reduce now ...?
>
> > Documentation/scsi/sym53c8xx_2.txt:by the 53c7xx and 53c8xx family.
> > Documentation/scsi/ncr53c8xx.txt:by the 53c7xx and 53c8xx family.
> > drivers/scsi/zalon.c: * Zalon 53c7xx device driver.
>
> Here it's being used as the name of the chip.
>
> > drivers/scsi/a4000t.c: * plus modifications of the 53c7xx.c driver to support the Amiga.
> > drivers/scsi/zorro7xx.c: * plus modifications of the 53c7xx.c driver to support the Amiga.
>
> This is part of the credit being given to Alan Hourihane.  I don't see
> how you can remove it.

  sorry, i wasn't suggesting removing *all* of that, just doing a
mindless grep and posting the results.  whether anyone wants to
process any of that is their call.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
