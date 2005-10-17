From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] procfs support for sgiwd93
Date: Mon, 17 Oct 2005 11:49:49 +0100
Message-ID: <20051017104949.GA22861@infradead.org>
References: <20051015013824.GA25248@linux-mips.org> <20051017104312.GB22710@infradead.org> <20051017104729.GB4884@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7343 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932263AbVJQKtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 06:49:50 -0400
Content-Disposition: inline
In-Reply-To: <20051017104729.GB4884@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Mon, Oct 17, 2005 at 11:47:29AM +0100, Ralf Baechle wrote:
> On Mon, Oct 17, 2005 at 11:43:12AM +0100, Christoph Hellwig wrote:
> 
> > NACK, no more new procfs support for scsi driver.
> > 
> > The sgiwd93.h removal is fine, but please also mark all functions that
> > were in it previously static.
> 
> It's not like this is really adding procfs support; it's more wiring up a
> function in sgiwd93.c that exists anyway in wd33c93.c.

Which is bad enough.  A patch to remove the procfs code code from wd33c93.c
would be gentley accepted, though ;-)

