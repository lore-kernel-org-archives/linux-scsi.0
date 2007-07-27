From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 08:53:36 -0600
Message-ID: <20070727145336.GK21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437542538-git-send-email-matthew@wil.cx> <46AA05ED.2060208@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51795 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603AbXG0Oxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:53:37 -0400
Content-Disposition: inline
In-Reply-To: <46AA05ED.2060208@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:49:17AM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >Pass the Scsi_Host to the interrupt handler, rather than polling all
> >hosts for each interrupt.
> >Return IRQ_NONE if we didn't handle this interrupt
> >Don't set the IRQF_DISABLED flag; this is not a fast-executing interrupt
> >handler.
> >
> >Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> hrm.
> 
> I thought you had multiple scsi hosts per board?  Thus multiple scsi 
> hosts per interrupt?

Right.  We'll request the interrupt twice, each time with a different
scsi_host.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
