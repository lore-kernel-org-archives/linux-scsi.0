From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 13/17] smartpqi: remove timeout for cache flush operations
Date: Tue, 30 Aug 2016 09:13:14 +0200
Message-ID: <20160830071313.jbpg6uaitkg2jtn3@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222992420.31214.16768734205314588696.stgit@brunhilda>
 <20160829093941.uuuoamnrzwjei3fs@c203.arch.suse.de>
 <4993A297653ECB4581FA5C3C31323D1916398C86@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41169 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751975AbcH3HNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Aug 2016 03:13:20 -0400
Content-Disposition: inline
In-Reply-To: <4993A297653ECB4581FA5C3C31323D1916398C86@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Viswas G <viswas.g@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Aug 29, 2016 at 09:36:32PM +0000, Don Brace wrote:
> > -----Original Message-----

[...]

> > 
> > IIRC I asked you to introduce this timeout, as you're calling
> > pqi_flush_cache() from the driver's shutdown callback and I still
> > doubt users like their shutdown's to hang indefinitely because cache
> > flush isn't working. Just my $0.02.
> > 
> 
> The issue is that we do not know how long to wait. The cache module has gotten
> quite large and some flush operations can take longer to complete than others.
> That is why we took the timeout value out.


OK, thanks for the clarification. I think we can still sort this out
when real non-theoretical issues arise.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
