From: Matthew Wilcox <willy@debian.org>
Subject: ppc64-sym2-fix.patch
Date: Wed, 15 Oct 2003 18:13:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031015171347.GE16535@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23739 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263697AbTJORNs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2003 13:13:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Andrew Morton <akpm@zip.com.au>, linux-scsi@vger.kernel.org


Hi Anton.  Looks like you forgot to cc me on this one:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.0-test7/2.6.0-test7-mm1/broken-out/ppc64-sym2-fix.patch

On first look, you're right.  We should do something more sensible if
pci_set_mwi() fails (eg, just report it to the user and carry on without
setting MWI).

But the comment indicates that some revisions of the 896 *require* MWI
to work around chip errata.  So I don't particularly want to do that.

The comment in include/asm-ppc64/pci.h seems to indicate that it actually
wouldn't do any harm to return success since the "hardware treats MWI
the same as memory write".

What do you think?

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
