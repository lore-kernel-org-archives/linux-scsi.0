From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PREEMPT-RT] [REPOST PATCH 1/5] scsi: bnx2i: convert to kworker
Date: Tue, 8 Nov 2016 08:24:34 +0100
Message-ID: <20161108072434.gnnhmrkkmxroy6dv@linux-x5ow.site>
References: <20160817101003.30055-1-bigeasy@linutronix.de>
 <20161107161901.GA12297@infradead.org>
 <alpine.DEB.2.20.1611071729030.3709@nanos>
 <20161107163848.GA1421@lst.de>
 <20161107164628.jrft3ovlp5myfvs5@linutronix.de>
 <20161107164846.GA1966@lst.de>
 <20161107170420.gc6jhsewglgkfsdi@linutronix.de>
 <20161107191025.GA5357@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751687AbcKHHYh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 02:24:37 -0500
Content-Disposition: inline
In-Reply-To: <20161107191025.GA5357@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>

On Mon, Nov 07, 2016 at 08:10:25PM +0100, Christoph Hellwig wrote:
> On Mon, Nov 07, 2016 at 06:04:21PM +0100, Sebastian Andrzej Siewior wrote:
> > So we keep things as they are right now or are we getting also rid of
> > the internal list? This was tested by Johannes and Chad (claimed to do
> > testing)
> 
> IFF the patches actually are tested as-is let's get them in.  I don't
> think they are how we want the code to like in the long run, though.

I'm definitively sure I did test the bnx2fc patches. I'm not 100% sure I did
test the bnx2i patches as well (althoug I wrote "for the whole series").
Testing was IIRC booting from the FCoE LUN and the doing a series of fio tests
for about an hour.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
