From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 3ware queue depth [was: Re: HIGHMEM4G config for 1GB RAM on desktop?]
Date: Wed, 1 Sep 2004 12:43:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040901124330.A10772@infradead.org>
References: <200408021602.34320.swsnyder@insightbb.com> <1094030083l.3189l.2l@traveler> <1094030194l.3189l.3l@traveler> <200409010233.31643.lkml@lpbproductions.com> <1094032735l.3189l.7l@traveler> <20040901110944.A10160@infradead.org> <1094036919l.3189l.11l@traveler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:29956 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266155AbUIALne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 07:43:34 -0400
Content-Disposition: inline
In-Reply-To: <1094036919l.3189l.11l@traveler>; from miquels@cistron.nl on Wed, Sep 01, 2004 at 11:08:39AM +0000
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Christoph Hellwig <hch@infradead.org>, lkml@lpbproductions.com, Timothy Miller <miller@techsource.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 01, 2004 at 11:08:39AM +0000, Miquel van Smoorenburg wrote:
> Anyway here's the minimal patch against 2.6.9-rc1
> 
> [PATCH] 3w-xxxx.c queue depth
> 
> make 3w-xxxx.c queue_depth sysfs parameter writable, adjust initial
> queue nr_requests to 2*queue_depth

Looks good to me.

