From: Matthew Wilcox <matthew@wil.cx>
Subject: sym2 git tree
Date: Wed, 16 Nov 2005 10:22:16 -0700
Message-ID: <20051116172216.GC31729@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42979 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932296AbVKPRWR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 12:22:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi.  I've set up a git tree for patches to the sym2 driver.  You can
fetch it from:

	git://git.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git

Current shortlog:

Christoph Hellwig:
      [SYM2] Remove last vestiges of sym_sniff_inquiry
      [SYM2] Manage sym_lcb properly
      [SYM2] Remove code to handle DMA_BIDIRECTION requests

Matthew Wilcox:
      [SYM2] Remove FreeBSD ifdefs
      [SYM2] Use DMA_40BIT_MASK constant
      [SYM2] Disable IU and QAS negotiation

I want to squash the PPR negotiation bug (4829) soon, probably today.
James, do you want to take all this via scsi-misc or shall I send Linus
pull requests at my discretion?
