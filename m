From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch][0/15] qlogicfas/qlogic_cs
Date: Tue, 9 Mar 2004 15:20:02 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309152002.A9111@infradead.org>
References: <20031020232200.GA473@cathedrallabs.org> <20040219150747.A23822@infradead.org> <20040219172619.GA667@cathedrallabs.org> <1077399404.2285.10.camel@mulgrave> <20040309133217.GB651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:58898 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261992AbUCIPUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 10:20:07 -0500
Content-Disposition: inline
In-Reply-To: <20040309133217.GB651@cathedrallabs.org>; from aris@cathedrallabs.org on Tue, Mar 09, 2004 at 10:32:17AM -0300
List-Id: linux-scsi@vger.kernel.org
To: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 09, 2004 at 10:32:17AM -0300, Aristeu Sergio Rozanski Filho wrote:
> > I'll put them in, but first I think the qlogicfas attachment type needs
> > to be all new style.
> please drop all patches that I've sent before and consider applying these
> I'm sending instead. I wonder if will be worth to split qlogicfas in two
> different modules: one for hardware functions and other for qlogicfas driver
> so qlogic_cs can share the same code instead copying it. comments?

I think that would be a good idea.
