From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] sym 2.1.18f
Date: Mon, 13 Oct 2003 16:19:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031013151901.GQ27861@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37582 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261801AbTJMPTE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2003 11:19:04 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org


Can people hammer on this patch please?  I'd like this to be the version
that ships in 2.6.0.

2.1.18f:
 - Rewrite the Kconfig help
 - Always honour CONFIG_SCSI_SYM53C8XX_IOMAPPED.  Alpha people used to
   have it forced off, Sparc people used to have it forced on.  (Thanks
   to Dann Frazier for testing on Alpha)
 - Simplify the NVRAM handling a bit.
 - SYM_OPT_NO_BUS_MEMORY_MAPPING is never set.
 - Remove PCI DMA abstraction.  (Christoph Hellwig)
 - Redo SCSI midlayer registration and unregistration to allow module
   load/unload to work.  Now copes with scsi_add_host() failing.  (Thanks
   to Brian King for testing)
 - Replace bcmp() with memcmp().
 - Change the MAINTAINER entry to myself.

http://ftp.linux.org.uk/pub/linux/willy/patches/sym-2.1.18f.diff

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
