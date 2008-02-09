From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: can all 53c7xx-related stuff be removed?
Date: Sat, 9 Feb 2008 11:49:48 -0700
Message-ID: <20080209184947.GC28967@parisc-linux.org>
References: <alpine.LFD.1.00.0802091151440.5998@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35104 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYBIStt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 13:49:49 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802091151440.5998@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-scsi@vger.kernel.org

On Sat, Feb 09, 2008 at 11:54:43AM -0500, Robert P. J. Day wrote:
>   just an observation that, even though 53c7xx content has been
> officially removed, there are still a few droppings hanging around the
> tree:

Erm.  It's not just a driver, it's also the name of some chips.

> $ grep -r 53c7xx *
> arch/m68k/Makefile:# without -fno-strength-reduce the 53c7xx.c driver fails ;-(

Ask the m68k guys.  Obviously, the comment can go away, but maybe they
want to remove -fno-strength-reduce now ...?

> Documentation/scsi/sym53c8xx_2.txt:by the 53c7xx and 53c8xx family.
> Documentation/scsi/ncr53c8xx.txt:by the 53c7xx and 53c8xx family.
> drivers/scsi/zalon.c: * Zalon 53c7xx device driver.

Here it's being used as the name of the chip.

> drivers/scsi/a4000t.c: * plus modifications of the 53c7xx.c driver to support the Amiga.
> drivers/scsi/zorro7xx.c: * plus modifications of the 53c7xx.c driver to support the Amiga.

This is part of the credit being given to Alan Hourihane.  I don't see
how you can remove it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
