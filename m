From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 3ware queue depth [was: Re: HIGHMEM4G config for 1GB RAM on desktop?]
Date: Wed, 1 Sep 2004 12:43:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040901194325.GA11762@beaverton.ibm.com>
References: <200408021602.34320.swsnyder@insightbb.com> <1094030083l.3189l.2l@traveler> <1094030194l.3189l.3l@traveler> <200409010233.31643.lkml@lpbproductions.com> <1094032735l.3189l.7l@traveler> <20040901110944.A10160@infradead.org> <1094036919l.3189l.11l@traveler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:58759 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267452AbUIAToc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2004 15:44:32 -0400
Content-Disposition: inline
In-Reply-To: <1094036919l.3189l.11l@traveler>
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Christoph Hellwig <hch@infradead.org>, lkml@lpbproductions.com, Timothy Miller <miller@techsource.com>, Jens Axboe <axboe@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 01, 2004 at 11:08:39AM +0000, Miquel van Smoorenburg wrote:

> +	/* make sure blockdev queue depth is at least 2 * scsi depth */
> +	if (SDptr->request_queue->nr_requests < 2 * max_cmds)
> +		SDptr->request_queue->nr_requests = 2 * max_cmds;

Why would you want nr_requests different (and larger) only for this
driver?

Is modifying nr_requests allowed?

-- Patrick Mansfield
