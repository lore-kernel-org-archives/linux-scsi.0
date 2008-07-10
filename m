From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Thu, 10 Jul 2008 07:45:18 -0400
Message-ID: <20080710114518.GC15464@devserv.devel.redhat.com>
References: <E1KGa1W-0004nG-Cw@n2o.xs4all.nl> <20080709113547.19235.15424.stgit@warthog.procyon.org.uk> <4561.1215612914@redhat.com> <1215629381.18506.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbYGJLqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 07:46:10 -0400
Content-Disposition: inline
In-Reply-To: <1215629381.18506.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 09, 2008 at 08:49:41PM +0200, Miquel van Smoorenburg wrote:
> Oh dear, that's indeed bad. Looks like that should use i2o_dma_alloc()
> instead. (drivers/scsi/dpt_i2o.c gets this right).
> 
> (and what's with the (unlocked!) pci_set_dma_mask() flipping in
> i2o_dma_alloc() ? )

Vomitous crap someone added with other horrible Adaptec bits. I've just posted
a patch that I think sorts the worst of it out.

Alan

