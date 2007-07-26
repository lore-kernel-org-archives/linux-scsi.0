From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 14:16:27 -0400
Message-ID: <46A8E4FB.8040908@garzik.org>
References: <20070726171141.GE19275@parisc-linux.org> <11854705779-git-send-email-matthew@wil.cx> <20070726180112.GA3392@infradead.org> <20070726180446.GI19275@parisc-linux.org> <20070726180617.GJ19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50195 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762423AbXGZSQb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 14:16:31 -0400
In-Reply-To: <20070726180617.GJ19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jul 26, 2007 at 12:04:46PM -0600, Matthew Wilcox wrote:
>> That happened in patch 4.  The function that looks for ISA and VL is still
>> called advansys_detect, but I can rename it to advansys_probe_legacy if
>> you want.

> git-format-patch's --start-number option.  This patch, anyway:
> http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-26/0004-advansys-Convert-to-pci_register_driver-interface.txt

In that case, reverse what I said:  the above pci_register_driver commit 
breaks non-PCI probing.

advansys_detect/release populate legacy list, but nothing ever happens 
from there...  your "Move to scsi hotplug initialisation model" patch 
fixes this bug, I presume.

	Jeff


