From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 12:06:18 -0600
Message-ID: <20070726180617.GJ19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org> <11854705779-git-send-email-matthew@wil.cx> <20070726180112.GA3392@infradead.org> <20070726180446.GI19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60353 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936153AbXGZSGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:06:19 -0400
Content-Disposition: inline
In-Reply-To: <20070726180446.GI19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 12:04:46PM -0600, Matthew Wilcox wrote:
> That happened in patch 4.  The function that looks for ISA and VL is still
> called advansys_detect, but I can rename it to advansys_probe_legacy if
> you want.

Um.  That's patch 4/22 ... or patch 3/21.  I knew I should have used
git-format-patch's --start-number option.  This patch, anyway:
http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-26/0004-advansys-Convert-to-pci_register_driver-interface.txt

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
