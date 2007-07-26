From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 12:29:34 -0600
Message-ID: <20070726182933.GK19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org> <11854705779-git-send-email-matthew@wil.cx> <20070726180112.GA3392@infradead.org> <20070726180446.GI19275@parisc-linux.org> <20070726180617.GJ19275@parisc-linux.org> <46A8E4FB.8040908@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47760 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXGZS3f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:29:35 -0400
Content-Disposition: inline
In-Reply-To: <46A8E4FB.8040908@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 02:16:27PM -0400, Jeff Garzik wrote:
> In that case, reverse what I said:  the above pci_register_driver commit 
> breaks non-PCI probing.

Ah yes.  Fair point.

> advansys_detect/release populate legacy list, but nothing ever happens 
> from there...  your "Move to scsi hotplug initialisation model" patch 
> fixes this bug, I presume.

Looks like it.  I don't know of any testers with non-PCI cards though.

Anyone out there with a non-PCI advansys card want to do some testing
for me?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
