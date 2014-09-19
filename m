From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] scsi-mq: Add support for multiple hardware queues
Date: Fri, 19 Sep 2014 11:11:42 -0700
Message-ID: <20140919181142.GA24696@infradead.org>
References: <541C27BF.6070609@acm.org>
 <541C281E.9090206@acm.org>
 <CAF9gx6JfP2bGyMauB6LzepZP_vKEvrd-sPZc5CRuOrtgQ_UCSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaISSLn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 14:11:43 -0400
Content-Disposition: inline
In-Reply-To: <CAF9gx6JfP2bGyMauB6LzepZP_vKEvrd-sPZc5CRuOrtgQ_UCSw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

On Fri, Sep 19, 2014 at 09:05:53PM +0300, Sagi Grimberg wrote:
> I think this patch should be squashed with passing LLD hctx patch (in
> whatever form it ends up).

Agreed.
