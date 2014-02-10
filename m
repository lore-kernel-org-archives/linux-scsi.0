From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/17] scsi: add support for per-host cmd pools
Date: Mon, 10 Feb 2014 04:20:21 -0800
Message-ID: <20140210122021.GA1224@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124019.946278511@bombadil.infradead.org>
 <52F4A8C4.8080602@cs.wisc.edu>
 <20140207124640.GC30510@infradead.org>
 <52F5539B.8090202@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBJMU2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 07:20:28 -0500
Content-Disposition: inline
In-Reply-To: <52F5539B.8090202@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Fri, Feb 07, 2014 at 03:43:55PM -0600, Mike Christie wrote:
> We need something like the attached patch which just prevents scsi-ml
> from creating a host pool when mq is used. Note that when
> scsi_destroy_command_freelist is called shost->cmd_pool will be NULL so
> it will return immediately so no extra check is needed in there.

Oops, missed your attached patch and pushed a similar of mine instead,
but the effect should be the same.

Btw, if you can split out the cmd_size bits of the iscsi patch so that
we can send it to James with the command part of the first series I'd
appreciate that.
