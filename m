From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 10 Sep 2014 11:09:57 -0700
Message-ID: <20140910180957.GA17495@infradead.org>
References: <540FCB96.8000606@interlog.com>
 <20140910154144.GA22296@infradead.org>
 <541080B5.8080505@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaIJSJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 14:09:58 -0400
Content-Disposition: inline
In-Reply-To: <541080B5.8080505@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Sep 10, 2014 at 10:47:49AM -0600, Jens Axboe wrote:
> BTW, please don't mix up the REQ_END and ->queue_rq() changes with the
> changed start_request API.

I have to.  It's set by start_request, so we need to pass down the last
argument to keep the old behavior.  And once we pass the argument we
can just it directly.

