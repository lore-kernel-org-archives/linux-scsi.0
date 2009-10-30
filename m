From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Fri, 30 Oct 2009 01:05:58 -0400
Message-ID: <20091030050558.GC17714@infradead.org>
References: <20091029150830.497006534@bombadil.infradead.org> <20091029151127.257902381@bombadil.infradead.org> <yq1ws2dsh4g.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZJ3FFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2009 01:05:55 -0400
Content-Disposition: inline
In-Reply-To: <yq1ws2dsh4g.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

On Thu, Oct 29, 2009 at 11:19:43PM -0400, Martin K. Petersen wrote:
> ACS-2 doesn't currently have a notion of unmap granularity and all array
> vendors I have talked to appear to happily process any unmap request we
> throw at them.  So I'm leaning towards keeping things simple and just
> sending things down verbatim...

We have all the granularity and alignment information avilable and
keeping track of it is simple enough.  Yes md/dm will need to update
the first aligned unmap sector, but they'll also need to update the
first aligned LBA for I/O purposes and adding more more is simple
enough.

Given that these bits are in the standard vendors will use them sooner
or later and I'd rather be prepared if it's simple enough.

