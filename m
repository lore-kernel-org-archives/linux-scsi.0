From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sym2 git tree
Date: Thu, 17 Nov 2005 11:50:31 -0700
Message-ID: <20051117185031.GE17171@parisc-linux.org>
References: <20051116172216.GC31729@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59343 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932489AbVKQSuc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 13:50:32 -0500
Content-Disposition: inline
In-Reply-To: <20051116172216.GC31729@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: peter.missel@onlinehome.de, f.hinzmann@hamburg.de, daniel@virtutech.com, ruben@auger.org.ar, hson@ludd.luth.se

On Wed, Nov 16, 2005 at 10:22:16AM -0700, Matthew Wilcox wrote:
> Hi.  I've set up a git tree for patches to the sym2 driver.  You can
> fetch it from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git

I'd like people to test this tree, particularly those who're on the cc list
since they're people who've reported bugs that this update should fix.

Here's the current shortlog:

Christoph Hellwig:
      [SYM2] Remove last vestiges of sym_sniff_inquiry
      [SYM2] Manage sym_lcb properly
      [SYM2] Remove code to handle DMA_BIDIRECTION requests

Matthew Wilcox:
      [SYM2] Remove FreeBSD ifdefs
      [SYM2] Use DMA_40BIT_MASK constant
      [SYM2] Disable IU and QAS negotiation
      [SYM2] Negotiate correctly with async-only devices
      [SYM2] Use scsi_print_msg
      [SYM2] Allow NVRAM settings to limit speed and width
      [SYM2] Report disabled devices and LUNs more attractively
      [SYM] Version 2.2.2
