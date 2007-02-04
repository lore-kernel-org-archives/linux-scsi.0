From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC7xxx on 2.6.18
Date: Sun, 4 Feb 2007 09:11:51 -0500
Message-ID: <20070204141151.GA28726@animx.eu.org>
References: <20070128194620.GA6358@animx.eu.org> <20070128162408.9fffb6de.akpm@osdl.org> <20070203004201.GB25027@animx.eu.org> <1170558221.3860.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:52641 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbXBDOMp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Feb 2007 09:12:45 -0500
Content-Disposition: inline
In-Reply-To: <1170558221.3860.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Keep me in CC, I'm not on the list.

James Bottomley wrote:
> On Fri, 2007-02-02 at 19:42 -0500, Wakko Warner wrote:
> > [   40.154122] ACPI: PCI Interrupt 0000:05:01.1[B] -> GSI 17 (level,
> > low) -> IRQ 22
> > [   40.158190] scsi4: PCI error Interrupt at seqaddr = 0x1bb
> > [   40.158261] scsi4: Signaled a Target Abort
> 
> Well, this is the source of the problem.  It means the driver detected
> an error in the PCI system.  I'm afraid I don't know what a PCI target
> error is, but I think it means something is wrong with the PCI bus in
> your system.  There's also a screaming interrupt, because the first 500
> interrupts will be ignored before it looks at the bus error register.

What I don't understand is that it works fine if I load the module first
then and exec init.  If the ID is 05:01.1, this is the 2nd channel provided
by the aha-2940u/uw card.  There's nothing attached to that channel.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
