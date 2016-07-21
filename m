From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
Date: Wed, 20 Jul 2016 22:53:51 -0700
Message-ID: <20160721055351.GA14568@infradead.org>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbcGUFxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 01:53:53 -0400
Content-Disposition: inline
In-Reply-To: <1468934439-93579-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.com>

On Tue, Jul 19, 2016 at 03:20:39PM +0200, Hannes Reinecke wrote:
> Add a return value BLK_MQ_RQ_QUEUE_DONE to terminate a request
> without error.

NAK.  You can just do a blk_mq_end_request on the request and return
0 from ->queue_rq.
