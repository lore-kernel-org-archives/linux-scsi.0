From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 8/24] advansys: Rewrite resource management
Date: Fri, 27 Jul 2007 08:43:20 -0600
Message-ID: <20070727144320.GH21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437534057-git-send-email-matthew@wil.cx> <46AA038A.2010203@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56502 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761372AbXG0OnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:43:21 -0400
Content-Disposition: inline
In-Reply-To: <46AA038A.2010203@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:39:06AM -0400, Jeff Garzik wrote:
> Ancillary comments:
> 
> 1) It is a common style to
> 
> 	#define DRV_NAME "advansys"
> 
> at the top, and then use DRV_NAME in request_region() calls, 
> request_irq() calls, struct eisa_driver, struct pci_driver, ...

Yup.

> 2) A future cleanup might add __FUNCTION__ to ASC_PRINTx, eliminating a 
> lot of manual reproduction of same

Goodness, yes.  Again, a can of worms I haven't had the heart to use the
opener on yet.  Also ASC_DBG needs to be turned into pr_debug.

Thee's so much yuck in this driver, I've had a hard time staying focused
on cleaning up only one thing at a time.

Did you mention 'remove internal queueing' yet?  If not, I beat you to
it ;-)

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
