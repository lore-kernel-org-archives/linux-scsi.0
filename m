From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10] remove scsi_request usage from sg and st
Date: Thu, 10 Nov 2005 10:55:13 +0000
Message-ID: <20051110105513.GA9118@infradead.org>
References: <1131444389.23111.56.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61888 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750775AbVKJKzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 05:55:20 -0500
Content-Disposition: inline
In-Reply-To: <1131444389.23111.56.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

On Tue, Nov 08, 2005 at 04:06:29AM -0600, Mike Christie wrote:
> The following patches, made against scsi-misc, remove the scsi_request
> usage from st and sg, do some tiny cleanup on sg, and make sg and st
> always perform scatterlist IO.
> 
> I have tested against libata and scsi_debug for disks. There are slight
> changes, so someone with a tape device should test the patches, but Kai
> since Kai did all the debugging last round I have not made many changes.
> We will probably hit many problems with LLDs using low max_hw_sectors,
> because they have not been converted to export their real values on the
> host template so I think these patches should sit in scsi-misc for a
> good deal of time.

looks like linus is closing the big merge window for 2.6.15, so we won't
be able to get this in fully.  What do you thing about getting in the
infrastructure at least, that is patches: 1,3,6,7 for 2.6.15 and the rest
afterwards, after the max_sectors thing has settled a little?

