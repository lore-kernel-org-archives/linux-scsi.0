From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Mon, 30 Apr 2007 19:52:08 +0200
Message-ID: <20070430175208.GQ21015@kernel.dk>
References: <20070427214709.DC44BDBA2@gherkin.frus.com> <1177712499.3688.25.camel@mulgrave.il.steeleye.com> <20070430173243.GP21015@kernel.dk> <20070430173927.GA10522@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:5093 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946540AbXD3R4b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2007 13:56:31 -0400
Content-Disposition: inline
In-Reply-To: <20070430173927.GA10522@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Apr 30 2007, Christoph Hellwig wrote:
> On Mon, Apr 30, 2007 at 07:32:45PM +0200, Jens Axboe wrote:
> > It's due to the crappy ->generic_packet() ioctl stuff, it bypasses the
> > block layer. So that needs to be converted to use block pc requests and
> > the block layer interface, then things will just work.
> > 
> > Christoph had a sort-of ready patch for that some time ago. Christoph,
> > did that ever materialize into a full blown patch?
> 
> I had a fullblown patch somewhere.  The only drawback was that I didn't
> convert pcd because I neither understand enough of the hardware nor do
> I really understand what's going on there.

Cool, pass the patch and I'll try to see if I can convert pcd.

-- 
Jens Axboe

