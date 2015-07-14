From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix host max depth checking for the 'queue_depth' sysfs
 interface
Date: Tue, 14 Jul 2015 00:13:58 -0700
Message-ID: <20150714071358.GA31117@infradead.org>
References: <20150713142439.GA14427@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:56409 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbbGNHOd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 03:14:33 -0400
Content-Disposition: inline
In-Reply-To: <20150713142439.GA14427@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I wonder if we should start to gradually phase out these tuables in the
host template.  It's not really more complicated to set them directly
in the host anyway.
