From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [Emulex] queuecommands and GFP_ATOMIC
Date: Tue, 8 Jun 2004 20:09:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608190922.GA8115@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F9470@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:5095 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265292AbUFHTJY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 15:09:24 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9470@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Anton Blanchard <anton@samba.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Jun 08, 2004 at 03:06:58PM -0400, Smart, James wrote:
> Actually, we are using spin_unlock_irq().  We're looking further...  I take
> it from your response, this calling sequence should not have been an issue ?

Umm, sorry.  I misread your mail, it clearly states:

> > > Debug: sleeping function called from invalid context at 
> > mm/slab.c:1980
> > > in_atomic():1, irqs_disabled():0
> > > Call Trace:

so you do have irqs enabled but are still in some critical section.

Can you post a snapshot of the codebase you're testing with?

